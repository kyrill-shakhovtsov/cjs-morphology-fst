#!/usr/bin/perl -w

use gv;

sub out_edges {
	my @edges;
	my $i = 0;
	print $_[0], "\n";
	$edges[$i] = gv::firstout($_[0]);
	print $edges[0], $#edges, "\n";
	do {
		$i++;
		$edges[$i] = gv::nextout($_[0], $edges[$i - 1]);
		print $#edges, "\n";
	} until ($edges[$i] == $edges[$i - 1]);
	return @edges;
}

sub out_nodes {
	my @nodes;
	my $i = 0;
	$nodes[$i] = gv::firsthead($_[0]);
# 	print gv::nameof($nodes[$i]), "\n";
	do {
		$i++;
		$nodes[$i] = gv::nexthead($_[0], $nodes[$i - 1]);
# 		print gv::nameof($nodes[$i]), "\n";
	} while ($nodes[$i]);
	pop @nodes;
	return @nodes;
}

if (!$ARGV[0]) {
	print "Использование: lex2dot.pl файл.lexc [файл.gv]\n";
	exit(0);
}

if (!$ARGV[1]) {
	$ARGV[1] = $ARGV[0].".gv";
}

open(LEXC, $ARGV[0]);

$g = gv::digraph("LEXC");
gv::setv($g, "concentrate", "true");
gv::setv($g, "label", $ARGV[0]);
gv::setv($g, "fontname", "PT Sans");
gv::setv($g, "fontsize", "18");

$pn = gv::protonode($g);
gv::setv($pn, "fontname", "PT Sans");
gv::setv($pn, "fontsize", "14");
gv::setv($pn, "fontcolor", "indigo");
gv::setv($pn, "shape", "none");

$pe = gv::protoedge($g);
gv::setv($pe, "color", "gray40");

while (<LEXC>) {
	chomp;
	if (m/^\s*LEXICON/) {
		@lex = split(/\s+/, $_, 3);
		$lexh = gv::node($g, $lex[1]);
		if ($lex[2]) {
			$lex[2] =~ s/!\s*//;
			gv::setv($lexh, "label", $lex[1].('\n'.$lex[2] // ' '));
		} else {
			gv::setv($lexh, "label", $lex[1]);
		}
		if ($lex[1] =~ m/Tag/) {
			gv::setv($lexh, "fontcolor", "tomato4");
			(undef, $tag) = split(/_/, $lex[1], 2);
			gv::setv($lexh, "label", "Tag [".$tag."]");
		}
		if ($lex[1] =~ m/V_/) {
			gv::setv($lexh, "fontcolor", "darkgreen");
		}
		if ($lex[1] =~ m/N_/) {
			gv::setv($lexh, "fontcolor", "navy");
		}
		if ($lex[1] =~ m/A_/) {
			gv::setv($lexh, "fontcolor", "orange4");
		}
	}

	if (m/^[^!].+;/) {
		@line = split(/;/, $_, 2);
		$cc = (split(/\s+/, $line[0]))[-1];
		if ($cc eq "#") {
			$cc= $lex[1]."_#";
			$cch = gv::node($g, $cc);
			gv::setv($cch, "label", "#");
			gv::setv($cch, "color", "firebrick");
			gv::setv($cch, "shape", "doublecircle");
		} else {
			$cch = gv::node($g, $cc);
		}

		if (!gv::findedge($lexh, gv::findnode($g, $cc))) {
			gv::edge($lexh, $cch);
		}
	}
}

close(LEXC);

if ($ARGV[2]) {
	$r = gv::findnode($g, $ARGV[2]);
	foreach $e (out_edges($r)) {
		gv::rm($e);
	}
}


$rh = gv::findnode($g, "Root");
gv::setv($rh, "shape", "circle");
gv::setv($rh, "color", "firebrick");
gv::setv($rh, "style", "filled");
gv::setv($rh, "fillcolor", "blanchedalmond");

$sg = gv::graph($g, "POS");
gv::setv($sg, "rank", "same");
foreach $n (out_nodes($rh)) {
	gv::node($sg, gv::nameof($n));
}

$sg = gv::graph($g, "Tags");
gv::setv($sg, "rank", "same");
gv::node($sg, "Tag_N");
gv::node($sg, "Tag_V");
gv::node($sg, "Tag_A");

gv::write($g, $ARGV[1]);
