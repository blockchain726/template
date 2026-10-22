#!/usr/bin/env bash
# Third pass: the verticals that harvest2 missed because arXiv rate-limited it
# (503 / "Rate exceeded") and the script mistook the error for zero results.
# This pass detects throttling explicitly and backs off.
set -u
cd "$(dirname "$0")"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/131.0 Safari/537.36"
mkdir -p papers meta
: > meta/candidates3.txt
: > meta/harvest3.log
log() { echo "$*" | tee -a meta/harvest3.log; }

# Returns 0 and leaves the feed in $2 only when it is a real Atom response.
fetch_feed() {
  local url="$1" out="$2" try
  for try in 1 2 3 4; do
    curl -sL -A "$UA" --max-time 45 "$url" -o "$out"
    if grep -q '<feed' "$out" 2>/dev/null; then return 0; fi
    log "      throttled/err (attempt $try): $(head -c 40 "$out" | tr -d '\n\r')"
    sleep $(( try * 20 ))
  done
  return 1
}

QUERIES=(
'healthcare|abs:%22large+language+models%22+AND+abs:%22healthcare%22'
'clinical|abs:%22large+language+models%22+AND+abs:%22clinical+decision%22'
'manufacturing|abs:%22large+language+models%22+AND+abs:%22manufacturing%22'
'telecom|abs:%22large+language+models%22+AND+abs:%22wireless+networks%22'
'software|abs:%22large+language+models%22+AND+abs:%22software+engineering%22'
'security|abs:%22large+language+models%22+AND+abs:%22cybersecurity%22'
'agents|abs:%22llm+agents%22+AND+abs:survey'
'science|abs:%22large+language+models%22+AND+abs:%22scientific%22'
'education|abs:%22large+language+models%22+AND+abs:%22education%22'
'distill|abs:%22knowledge+distillation%22+AND+abs:%22large+language+models%22'
'onprem|abs:%22open-source+large+language+models%22'
'guardrails|abs:%22safety+alignment%22+AND+abs:%22large+language+models%22'
'eval|abs:%22benchmark%22+AND+abs:%22large+language+models%22+AND+abs:survey'
'robotics|abs:%22large+language+models%22+AND+abs:%22robotics%22'
)

log "=== phase 1: searching (10s spacing, backoff on 503) ==="
for q in "${QUERIES[@]}"; do
  slug="${q%%|*}"; enc="${q#*|}"
  if fetch_feed "http://export.arxiv.org/api/query?search_query=${enc}&start=0&max_results=8&sortBy=relevance" "meta/u_${slug}.xml"; then
    ids=$(grep -oE '<id>http://arxiv.org/abs/[0-9]+\.[0-9]+' "meta/u_${slug}.xml" | grep -oE '[0-9]+\.[0-9]+' | sort -u)
    n=$(echo "$ids" | grep -c . || true)
    log "  $slug: $n hits"
    for i in $ids; do echo "$i" >> meta/candidates3.txt; done
  else
    log "  $slug: GAVE UP (persistent throttling)"
  fi
  sleep 10
done

sort -u meta/candidates3.txt -o meta/candidates3.txt
cut -f1 meta/licenses.tsv | sort -u > meta/seen3.txt
comm -23 meta/candidates3.txt meta/seen3.txt > meta/todo3.txt
log "new candidates: $(wc -l < meta/todo3.txt)"

log ""
log "=== phase 2: licences (5s spacing) ==="
while read -r id; do
  [ -z "$id" ] && continue
  ok=0
  for try in 1 2 3; do
    curl -sL -A "$UA" --max-time 45 \
      "http://export.arxiv.org/oai2?verb=GetRecord&identifier=oai:arXiv.org:${id}&metadataPrefix=arXiv" \
      -o meta/rec3.xml
    grep -q '<OAI-PMH' meta/rec3.xml 2>/dev/null && { ok=1; break; }
    sleep $(( try * 20 ))
  done
  if [ $ok -eq 0 ]; then log "  $id: throttled, skipped"; sleep 5; continue; fi
  lic=$(grep -oE '<license>[^<]*</license>' meta/rec3.xml | head -1 | sed 's/<[^>]*>//g')
  ttl=$(grep -oE '<title>.*</title>' meta/rec3.xml | head -1 | sed 's/<[^>]*>//g' | tr -s ' \n\t' ' ' | sed 's/^ //; s/ $//')
  [ -z "$lic" ] && lic="(none recorded)"
  printf '%s\t%s\t%s\n' "$id" "$lic" "$ttl" >> meta/licenses.tsv
  sleep 5
done < meta/todo3.txt

log ""
log "=== phase 3: downloading CC-BY / CC-BY-SA / CC0 only ==="
while IFS=$'\t' read -r id lic ttl; do
  case "$lic" in
    *creativecommons.org/licenses/by/4.0*|*creativecommons.org/licenses/by-sa/4.0*|*publicdomain/zero*) ;;
    *) continue ;;
  esac
  ls papers/arXiv-${id}-*.pdf >/dev/null 2>&1 && continue
  slug=$(printf '%s' "$ttl" | tr -cd 'A-Za-z0-9 -' | tr -s ' ' '-' | cut -c1-72 | sed 's/-$//')
  out="papers/arXiv-${id}-${slug}.pdf"
  curl -sL -A "$UA" --max-time 120 -o "$out" "https://arxiv.org/pdf/${id}"
  if [ -s "$out" ] && [ "$(head -c 5 "$out")" = "%PDF-" ]; then
    log "  OK   $(basename "$out") [$(stat -c %s "$out") bytes]"
  else log "  FAIL $id"; rm -f "$out"; fi
  sleep 4
done < <(grep -F -f meta/todo3.txt meta/licenses.tsv 2>/dev/null || true)

log ""
log "=== DONE: $(ls papers/*.pdf 2>/dev/null | wc -l) PDFs, $(du -sm papers 2>/dev/null | cut -f1) MB ==="
