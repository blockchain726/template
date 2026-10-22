#!/usr/bin/perl
# Render a plain-text RFC as print-ready HTML, honouring the form-feed (\f)
# page breaks that RFCs use and keeping the fixed-width layout intact.
use strict;
use warnings;
binmode(STDOUT, ':encoding(UTF-8)');

my $file = shift or die "usage: txt2html.pl <rfc.txt>\n";
open my $fh, '<:encoding(UTF-8)', $file or die "cannot open $file: $!";
local $/;
my $txt = <$fh>;
close $fh;

# Title: first non-blank line that is not the RFC header block, else the filename.
my $title = $file;
$title =~ s{.*[/\\]}{};
$title =~ s/\.txt$//i;
$title = uc $title;
$title =~ s/^RFC/RFC /;

# Split on form feeds into pages; strip trailing page-number lines' blank padding.
my @pages = split /\f/, $txt;

sub esc {
    my $s = shift;
    $s =~ s/&/&amp;/g;
    $s =~ s/</&lt;/g;
    $s =~ s/>/&gt;/g;
    return $s;
}

my $body = '';
for my $p (@pages) {
    $p =~ s/\A\n+//;
    $p =~ s/\s+\z//;
    next if $p eq '';
    $body .= '<div class="pg"><pre>' . esc($p) . "</pre></div>\n";
}

print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>$title</title>
<style>
  \@page { size: A4; margin: 14mm 14mm 14mm 16mm; }
  html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  body { margin: 0; }
  div.pg { page-break-after: always; }
  div.pg:last-child { page-break-after: avoid; }
  pre {
    font-family: Consolas, "DejaVu Sans Mono", "Courier New", monospace;
    font-size: 8.4pt; line-height: 1.32; margin: 0;
    white-space: pre; color: #111;
  }
</style>
</head>
<body>
$body</body>
</html>
HTML
