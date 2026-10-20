#!/usr/bin/perl
# Minimal Markdown -> HTML converter for the constrained subset used in the
# IIoT guides: ATX headings, paragraphs, bullet/numbered lists, pipe tables,
# fenced code blocks, thematic breaks, and inline code/bold/italic/links.
# Not a general CommonMark implementation - it only needs to handle our own files.
use strict;
use warnings;

binmode(STDOUT, ':encoding(UTF-8)');

my $title = shift @ARGV // 'Document';
my @files = @ARGV;

sub esc {
    my $s = shift;
    $s =~ s/&/&amp;/g;
    $s =~ s/</&lt;/g;
    $s =~ s/>/&gt;/g;
    return $s;
}

sub inline {
    my $s = shift;
    my @code;
    # protect code spans so bold/italic rules cannot rewrite their contents
    $s =~ s/`([^`]*)`/push @code, $1; "\x01" . $#code . "\x01"/ge;
    $s = esc($s);
    $s =~ s/\[([^\]]+)\]\(([^)\s]+)\)/<a href="$2">$1<\/a>/g;
    $s =~ s/&lt;(https?:\/\/[^&\s]+)&gt;/<a href="$1">$1<\/a>/g;
    $s =~ s/\*\*([^*]+)\*\*/<strong>$1<\/strong>/g;
    $s =~ s/(?<!\*)\*([^*\s][^*]*)\*(?!\*)/<em>$1<\/em>/g;
    $s =~ s/\x01(\d+)\x01/"<code>" . esc($code[$1]) . "<\/code>"/ge;
    return $s;
}

sub slug {
    my $s = lc shift;
    $s =~ s/[^a-z0-9]+/-/g;
    $s =~ s/^-|-$//g;
    return $s;
}

my @out;
my $first_file = 1;

for my $f (@files) {
    open my $fh, '<:encoding(UTF-8)', $f or die "cannot open $f: $!";
    my @lines = <$fh>;
    close $fh;
    chomp @lines;

    push @out, '<section class="guide' . ($first_file ? ' first' : '') . '">';
    $first_file = 0;

    my $i = 0;
    while ($i <= $#lines) {
        my $line = $lines[$i];

        # fenced code block
        if ($line =~ /^```/) {
            $i++;
            my @buf;
            while ($i <= $#lines && $lines[$i] !~ /^```/) {
                push @buf, esc($lines[$i]);
                $i++;
            }
            $i++;    # closing fence
            push @out, '<pre><code>' . join("\n", @buf) . '</code></pre>';
            next;
        }

        # pipe table
        if ($line =~ /^\s*\|/ && $i + 1 <= $#lines && $lines[$i + 1] =~ /^\s*\|[\s:|-]+\|?\s*$/) {
            my @hdr = split /\s*\|\s*/, $line;
            shift @hdr;    # leading empty field
            $i += 2;
            push @out, '<table>', '<thead><tr>';
            push @out, '<th>' . inline($_) . '</th>' for @hdr;
            push @out, '</tr></thead>', '<tbody>';
            while ($i <= $#lines && $lines[$i] =~ /^\s*\|/) {
                my @cells = split /\s*\|\s*/, $lines[$i], -1;
                shift @cells;
                pop @cells while @cells && (!defined $cells[-1] || $cells[-1] eq '');
                push @out, '<tr>';
                push @out, '<td>' . inline(defined $_ ? $_ : '') . '</td>' for @cells;
                push @out, '</tr>';
                $i++;
            }
            push @out, '</tbody></table>';
            next;
        }

        # headings
        if ($line =~ /^(#{1,6})\s+(.*)$/) {
            my $lvl = length $1;
            my $txt = $2;
            push @out, sprintf('<h%d id="%s">%s</h%d>', $lvl, slug($txt), inline($txt), $lvl);
            $i++;
            next;
        }

        # thematic break
        if ($line =~ /^\s*(---|\*\*\*|___)\s*$/) {
            push @out, '<hr />';
            $i++;
            next;
        }

        # lists (bullet or numbered), with hanging-indent continuation lines
        if ($line =~ /^\s*([-*]|\d+\.)\s+/) {
            my $ordered = ($line =~ /^\s*\d+\.\s/) ? 1 : 0;
            my $tag = $ordered ? 'ol' : 'ul';
            push @out, "<$tag>";
            my @item;
            my $flush = sub {
                return unless @item;
                push @out, '<li>' . inline(join(' ', @item)) . '</li>';
                @item = ();
            };
            while ($i <= $#lines) {
                my $l = $lines[$i];
                if ($l =~ /^\s*(?:[-*]|\d+\.)\s+(.*)$/) {
                    $flush->();
                    push @item, $1;
                    $i++;
                } elsif ($l =~ /^\s+(\S.*)$/ && @item) {
                    push @item, $1;    # continuation of current item
                    $i++;
                } else {
                    last;
                }
            }
            $flush->();
            push @out, "</$tag>";
            next;
        }

        # blank line
        if ($line =~ /^\s*$/) {
            $i++;
            next;
        }

        # paragraph: gather until blank or a block-level starter
        my @para;
        while ($i <= $#lines
            && $lines[$i] !~ /^\s*$/
            && $lines[$i] !~ /^```/
            && $lines[$i] !~ /^#{1,6}\s/
            && $lines[$i] !~ /^\s*\|/
            && $lines[$i] !~ /^\s*(?:[-*]|\d+\.)\s+/
            && $lines[$i] !~ /^\s*(?:---|\*\*\*|___)\s*$/)
        {
            push @para, $lines[$i];
            $i++;
        }
        push @out, '<p>' . inline(join(' ', @para)) . '</p>' if @para;
    }
    push @out, '</section>';
}

my $body = join "\n", @out;
my $esc_title = esc($title);

print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>$esc_title</title>
<style>
  \@page { size: A4; margin: 18mm 16mm 20mm 16mm; }
  html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  body {
    font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
    font-size: 9.6pt; line-height: 1.5; color: #1a1a1a; margin: 0;
  }
  section.guide { page-break-before: always; }
  section.guide.first { page-break-before: avoid; }
  h1 {
    font-size: 19pt; margin: 0 0 0.5em; padding-bottom: 0.25em;
    border-bottom: 2.5px solid #1f4e79; color: #1f4e79; line-height: 1.25;
  }
  h2 {
    font-size: 13pt; margin: 1.5em 0 0.4em; color: #1f4e79;
    border-bottom: 1px solid #c8d6e2; padding-bottom: 0.15em;
    page-break-after: avoid;
  }
  h3 { font-size: 11pt; margin: 1.2em 0 0.3em; color: #2c5f8d; page-break-after: avoid; }
  p { margin: 0.55em 0; orphans: 3; widows: 3; }
  ul, ol { margin: 0.5em 0 0.7em; padding-left: 1.5em; }
  li { margin: 0.22em 0; }
  code {
    font-family: Consolas, "Courier New", monospace; font-size: 0.9em;
    background: #f3f4f6; padding: 0.08em 0.3em; border-radius: 3px;
    border: 1px solid #e2e5e9;
  }
  pre {
    background: #f7f8fa; border: 1px solid #d8dde3; border-left: 3px solid #1f4e79;
    padding: 0.7em 0.9em; overflow-x: auto; page-break-inside: avoid;
    font-size: 8.3pt; line-height: 1.35; margin: 0.8em 0;
  }
  pre code { background: none; border: none; padding: 0; font-size: inherit; }
  table {
    border-collapse: collapse; width: 100%; margin: 0.8em 0;
    font-size: 8.5pt; page-break-inside: avoid;
  }
  th, td { border: 1px solid #c3cbd4; padding: 0.3em 0.45em; text-align: left; vertical-align: top; }
  th { background: #1f4e79; color: #fff; font-weight: 600; }
  tbody tr:nth-child(even) { background: #f4f6f8; }
  a { color: #1f4e79; text-decoration: none; word-break: break-word; }
  hr { border: none; border-top: 1px solid #d8dde3; margin: 1.4em 0; }
  strong { color: #11293d; }
</style>
</head>
<body>
$body
</body>
</html>
HTML
