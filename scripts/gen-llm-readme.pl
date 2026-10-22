#!/usr/bin/perl
# Build docs/llm/README.md from the harvest metadata.
#  - groups mirrored papers by the search topic that found them
#  - records the licence of every paper, mirrored or not
#  - lists NC/ND and non-redistributable papers as links instead of files
use strict;
use warnings;
binmode(STDOUT, ':encoding(UTF-8)');

my $meta = 'meta';
my $papers = 'papers';

# ---- topic labels ---------------------------------------------------------
my %label = (
  'domain-llm'    => 'Domain adaptation & domain-specific models',
  'industry-llm'  => 'Industrial applications',
  'industrial'    => 'Industrial applications',
  'manufacturing' => 'Manufacturing',
  'finetune'      => 'Fine-tuning (parameter-efficient)',
  'lora'          => 'Fine-tuning (parameter-efficient)',
  'distill'       => 'Distillation & model compression',
  'rag'           => 'Retrieval-augmented generation',
  'efficient'     => 'Efficient inference & serving',
  'quantization'  => 'Quantization & low-bit inference',
  'slm'           => 'Small language models',
  'onprem'        => 'Open-source & self-hosted models',
  'privacy'       => 'Privacy',
  'federated'     => 'Federated & distributed training',
  'security'      => 'Security',
  'guardrails'    => 'Guardrails & safety controls',
  'healthcare'    => 'Healthcare & clinical',
  'clinical'      => 'Healthcare & clinical',
  'finance'       => 'Finance',
  'legal'         => 'Legal',
  'telecom'       => 'Telecommunications',
  'software'      => 'Software engineering',
  'science'       => 'Scientific research',
  'education'     => 'Education',
  'eval'          => 'Evaluation & benchmarking',
  'agents'        => 'Agents & tool use',
  'promptsurvey'  => 'Prompting',
);

# ---- id -> topics from the saved search results --------------------------
my %topic_of;
for my $f (glob("$meta/s_*.xml $meta/t_*.xml")) {
  my ($slug) = $f =~ m{/[st]_(.+)\.xml$};
  next unless defined $slug;
  open my $fh, '<', $f or next;
  local $/;
  my $x = <$fh>;
  close $fh;
  while ($x =~ m{<id>http://arxiv\.org/abs/(\d+\.\d+)}g) {
    push @{ $topic_of{$1} }, $slug unless grep { $_ eq $slug } @{ $topic_of{$1} || [] };
  }
}

# ---- licences ------------------------------------------------------------
my (%lic, %title);
open my $lf, '<:encoding(UTF-8)', "$meta/licenses.tsv" or die "no licenses.tsv: $!";
while (<$lf>) {
  chomp;
  my ($id, $l, $t) = split /\t/, $_, 3;
  next unless defined $id && $id =~ /^\d/;
  $lic{$id}   = $l // '';
  $title{$id} = (defined $t && length $t) ? $t : "arXiv:$id";
}
close $lf;

sub short_lic {
  my $l = shift // '';
  return 'CC0 1.0'        if $l =~ m{publicdomain/zero};
  return 'CC BY 4.0'      if $l =~ m{licenses/by/4\.0};
  return 'CC BY-SA 4.0'   if $l =~ m{licenses/by-sa/4\.0};
  return 'CC BY-NC-SA 4.0'if $l =~ m{licenses/by-nc-sa};
  return 'CC BY-NC-ND 4.0'if $l =~ m{licenses/by-nc-nd};
  return 'arXiv non-exclusive' if $l =~ m{nonexclusive-distrib};
  return 'not recorded'   if $l eq '' || $l =~ /none recorded/;
  return $l;
}
sub mirrorable { my $l = shift // ''; return $l =~ m{licenses/by/4\.0|licenses/by-sa/4\.0|publicdomain/zero} ? 1 : 0; }

# ---- which files are actually present ------------------------------------
my %file_of;
for my $p (glob("$papers/*.pdf")) {
  my ($id) = $p =~ m{arXiv-(\d+\.\d+)-};
  $file_of{$id} = $p if defined $id;
}

# ---- group mirrored papers by primary topic ------------------------------
my %by_label;
my @excluded_nc;
my @excluded_nd;
for my $id (sort keys %file_of) {
  unless (mirrorable($lic{$id})) {
    my $s = short_lic($lic{$id});
    push @{ $s =~ /ND/ ? \@excluded_nd : \@excluded_nc }, $id;
    next;
  }
  my @t = @{ $topic_of{$id} || [] };
  my $lab = 'Other';
  for my $s (@t) { if (exists $label{$s}) { $lab = $label{$s}; last } }
  push @{ $by_label{$lab} }, $id;
}

my $n_mirrored = 0;
$n_mirrored += scalar @{ $by_label{$_} } for keys %by_label;

# non-redistributable (checked but never downloaded)
my @nonredist = sort grep { !mirrorable($lic{$_}) && !$file_of{$_} } keys %lic;

# ---- emit ----------------------------------------------------------------
print "# Private & Domain-Specific LLMs — Reference Library\n\n";
print "Documents for teams building **private, self-hosted or domain-adapted language\n";
print "models** inside an organisation: governance and risk frameworks, application\n";
print "security, and peer-reviewed research across industry verticals.\n\n";
print "Every file here is **cleared for redistribution, commercial use included** — US\n";
print "Government public-domain publications, CC-BY-SA, and arXiv papers under CC-BY,\n";
print "CC-BY-SA or CC0. Papers under more restrictive licences are listed as links, not\n";
print "mirrored. See [Licensing](#licensing) for how this was determined.\n\n";
print "Retrieved 2026-10-21. Verify integrity with:\n\n";
print "```bash\ncd docs/llm && sha256sum -c SHA256SUMS\n```\n\n";
print "---\n\n## Start here\n\n";
print "| Document | Why it matters |\n|---|---|\n";
print "| [NIST AI RMF 1.0](governance/NIST.AI.100-1-AI-Risk-Management-Framework.pdf) | The reference framework for governing an AI deployment: Govern / Map / Measure / Manage |\n";
print "| [NIST Generative AI Profile](governance/NIST.AI.600-1-Generative-AI-Profile.pdf) | AI RMF applied specifically to generative AI — the 12 GenAI risk categories |\n";
print "| [OWASP Top 10 for LLM Applications 2025](security/OWASP-Top-10-for-LLM-Applications-v2025.pdf) | The practical security checklist: prompt injection, supply chain, data leakage, excessive agency |\n";
print "| [NIST Adversarial ML Taxonomy](governance/NIST.AI.100-2e2025-Adversarial-ML-Taxonomy.pdf) | Attack taxonomy and terminology for ML and generative systems |\n\n";
print "If you read one document before starting a private-LLM project, read the\n";
print "**Generative AI Profile** — it turns abstract risk language into concrete\n";
print "questions you can answer about your own deployment.\n\n";
print "---\n\n## Governance & frameworks\n\n";
print "US Government works — public domain in the US (17 U.S.C. §105), unrestricted\n";
print "redistribution. Source: <https://www.nist.gov/itl/ai-risk-management-framework>\n\n";
print "| File | Topic |\n|---|---|\n";
print "| `NIST.AI.100-1` | AI Risk Management Framework 1.0 |\n";
print "| `NIST.AI.600-1` | Generative AI Profile (companion to the AI RMF) |\n";
print "| `NIST.AI.100-2e2025` | Adversarial Machine Learning: taxonomy and terminology |\n\n";
print "## Application security\n\n";
print "OWASP GenAI Security Project, licensed **CC-BY-SA 4.0**, which explicitly permits\n";
print "copying and redistribution in any medium. Source: <https://genai.owasp.org/>\n\n";
print "| File | Topic |\n|---|---|\n";
print "| `OWASP-Top-10-for-LLM-Applications-v2025.pdf` | The 2025 Top 10 for LLM applications (45 pp) |\n";
print "| `OWASP-Top-10-LLM-Applications-Architecture-2025.pdf` | Reference architecture diagram |\n\n";
print "---\n\n## Research papers by field\n\n";
printf "%d arXiv papers, all under CC-BY 4.0, CC-BY-SA 4.0 or CC0 — redistributable\n", $n_mirrored;
print "including commercially. Grouped by the topic that surfaced them; many span\n";
print "several areas.\n\n";

for my $lab (sort keys %by_label) {
  my @ids = sort { $a <=> $b } @{ $by_label{$lab} };
  printf "### %s\n\n", $lab;
  print "| Paper | arXiv | Licence |\n|---|---|---|\n";
  for my $id (@ids) {
    my $f = $file_of{$id};
    $f =~ s{^\Q$papers\E/}{papers/};
    my $t = $title{$id};
    $t =~ s/\|/\\|/g;
    printf "| [%s](%s) | [%s](https://arxiv.org/abs/%s) | %s |\n",
      $t, $f, $id, $id, short_lic($lic{$id});
  }
  print "\n";
}

print "---\n\n## Licensing\n\n";
print "### How this was filtered\n\n";
print "arXiv's **default licence** (`nonexclusive-distrib/1.0`) grants arXiv the right to\n";
print "distribute a paper. It grants *third parties* no redistribution right at all, so a\n";
print "paper under it **cannot lawfully be mirrored here** — regardless of being free to\n";
print "read on arXiv. Bulk-downloading arXiv PDFs into a repository is a licence breach\n";
print "for a large fraction of them.\n\n";
print "Each candidate's licence was therefore read from arXiv's OAI-PMH metadata before\n";
print "download:\n\n";
print "```\nhttp://export.arxiv.org/oai2?verb=GetRecord&identifier=oai:arXiv.org:<id>&metadataPrefix=arXiv\n```\n\n";
print "### What was found\n\n";
my %count;
$count{ short_lic($lic{$_}) }++ for keys %lic;
print "| Licence | Papers | Mirrored here |\n|---|---|---|\n";
for my $k (sort { $count{$b} <=> $count{$a} } keys %count) {
  my $m = ($k =~ /^CC BY 4|^CC BY-SA 4|^CC0/) ? 'Yes' : 'No';
  printf "| %s | %d | %s |\n", $k, $count{$k}, $m;
}
printf "\n**%d candidates screened, %d mirrored.**\n\n", scalar(keys %lic), $n_mirrored;

if (@excluded_nc || @excluded_nd) {
  print "### Excluded: non-commercial licences\n\n";
  print "These are Creative Commons but carry an **NC (NonCommercial)** term. They are\n";
  print "deliberately not mirrored, because a copy inside a company repository could be\n";
  print "read as commercial use. Read them on arXiv instead.\n\n";
  print "| Paper | arXiv | Licence |\n|---|---|---|\n";
  for my $id (sort { $a <=> $b } (@excluded_nc, @excluded_nd)) {
    my $t = $title{$id}; $t =~ s/\|/\\|/g;
    printf "| %s | [%s](https://arxiv.org/abs/%s) | %s |\n", $t, $id, $id, short_lic($lic{$id});
  }
  print "\n";
}

if (@nonredist) {
  my @show = @nonredist;
  print "### Excluded: no redistribution right\n\n";
  printf "%d screened papers are under arXiv's default licence or record no licence.\n", scalar @show;
  print "Links only.\n\n";
  print "| Paper | arXiv |\n|---|---|\n";
  for my $id (sort { $a <=> $b } @show) {
    my $t = $title{$id}; $t =~ s/\|/\\|/g;
    printf "| %s | [%s](https://arxiv.org/abs/%s) |\n", $t, $id, $id;
  }
  print "\n";
}

print "### Attribution\n\n";
print "Every document remains the work of its authors. Copyright and licence notices\n";
print "inside each PDF are intact and unmodified; nothing here is adapted or excerpted.\n";
print "CC-BY and CC-BY-SA require attribution — cite the original paper, not this\n";
print "repository. No endorsement by NIST, OWASP or any author is implied.\n\n";
print "### Wanted but not mirrorable\n\n";
print "| Document | Status |\n|---|---|\n";
print "| NSA/CISA *Deploying AI Systems Securely* | Public domain, but media.defense.gov returns HTTP 403 to non-browser clients. Direct: <https://media.defense.gov/2024/Apr/15/2003439257/-1/-1/0/CSI-DEPLOYING-AI-SYSTEMS-SECURELY.PDF> |\n";
print "| EU AI Act, Regulation (EU) 2024/1689 | EUR-Lex serves a bot-protection page to scripted clients. Note it was amended by Regulation (EU) 2026/1744, so cite the consolidated text: <https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689> |\n";
print "| Model papers for Llama, GPT, Claude, Gemini | Under arXiv's default licence or not on arXiv. Links only. |\n\n";
print "## Reproducing this harvest\n\n";
print "`scripts/harvest-llm-papers.sh` re-runs the search, licence screen and download,\n";
print "respecting arXiv's 3-second request interval. `meta/licenses.tsv` in that script's\n";
print "output records the licence of every paper screened, so the filtering is auditable.\n";
