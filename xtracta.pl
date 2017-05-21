#!/usr/bin/perl

#TODO write documentation


use strict;
use warnings;
use JSON;
use Data::Dumper;
use Getopt::Long qw(GetOptions);;


my $DEBUG = 0;
&GetOptions('debug|d' => \$DEBUG);


#print "DEBUG = $DEBUG\n";
print "xtracta test\n\n" if $DEBUG;

my $invoice_fname = 'invoice.txt';
my $supplier_fname = 'suppliernames.txt';

my $json_array;

print "reading input file $invoice_fname and decoding json data\n\n" if $DEBUG;

open (my $invoice_fh, '<', $invoice_fname) or die "error opening file $invoice_fname - $!";

while (<$invoice_fh>) {
    my $line = $_;

    #file is not in valid json format. could change the input file first but will do it programmatically here
    #this is just a quick way to do it. if the strings has apostrophes then there will be problems.
    #quickly eyeballed the data file sunce its small and fairly ok that this replacement is going to work.
    #proper solution would need to correct the input file properly.
    $line =~ s/\'/\"/g;

    my $json = decode_json($line);

    push @$json_array, $json;
}

#TODO move this below the commented out code to read whole json file if using it
close $invoice_fh;

=head

#TODO check if there is easy way to open and auto parse json file
#We can read whole file but the file in invalid format
my $invoice_data = do {local $/; <$invoice_fh>};
#print $invoice_data if $DEBUG;
    $invoice_data =~ s/\'/\"/g;
print $invoice_data if $DEBUG;


#open (OUT, '>', 'extracta_output.txt') or die "error opening file - $!"; 
#print OUT $invoice_data;
#close OUT;

#this is erroring "garbage after JSON object, at character offset 175 (before "{"pos_id": 1, "cspan...") at ./xtracta.pl line 31, <$invoice_fh> line 1."
#possibly decode_json() doens't like the end of line character??? wierd. 
    $file_hash = decode_json($invoice_data);

    print &Dumper($file_hash) if $DEBUG;

#    print $$json{'word'};
=cut

#print "\n\n\n";
#print &Dumper($json_array) if $DEBUG;


#process the data.
#get data into lines for each page
print "extracted json data. process the data and grab info we want which is the words on each line\n\n" if $DEBUG;

my $clean_data;
foreach (@$json_array) {
    my $hash = $_;
    foreach (keys %$hash) {
        $$clean_data{$$hash{'page_id'}}->{$$hash{'line_id'}}[$$hash{'pos_id'}] = $$hash{'word'};
    }
}

#read in suppliers
#its a csv file. its names text file tho so if the names have comma's then had more data issues to deal with the file first.
#TODO look for csv reader instead of doing my own
#One of the requirements is to make this script scalable to hundreds of thousands of suppliers.
#This will read the entire supplier file into memory to do the matching against the lines of words
#The list of suppliers would be small even at hundreds of thousands of records and won't cause probelms memory wise.
#This is my main approach with the focus on speed of processing.
#If memory is a limitation we could look at reading each supplier 1 at a time and doing the comparison.
#This will be slower processing wise but is more memory efficient.
print "get supplier data from $supplier_fname\n\n" if $DEBUG;
my $suppliers_hash;

open (my $supplier_fh, '<', $supplier_fname) or die "error opening file $supplier_fname - $!";

while (<$supplier_fh>) {
    chomp;
    my $line = $_;
    my ($id, $name) = split (',', $line);

    $$suppliers_hash{$id} = $name;
}

close $supplier_fh;

#do matching for each line

print "matching supplier data with words on a line to match supplier to invoice data\n\n" if $DEBUG;
foreach my $page_id (sort keys %$clean_data) {
    foreach my $line_id (sort keys %{$$clean_data{$page_id}}) {
        my ($words_on_line) = join (' ', @{$$clean_data{$page_id}{$line_id}});

        #I have the words on each line here
        #match against the supplier names

        foreach my $id (keys %$suppliers_hash) {
            if ($words_on_line =~ /$$suppliers_hash{$id}/) {
                 print "#############\nmatched supplier $$suppliers_hash{$id} (id $id). Found on page $page_id line $line_id\n#############\n\n";
            }
        }

        #TODO what if we have multiple matches.
        #TODO add output if no supplier found.
        #what if name is wierd? has hashes or spaces or extra spaces. would need ot adjust algorithm to accomodate bad data (from the invoice or supplier list
        #TODO this solution will not handle names on multiple lines
        #     will require much more complex logic to match that.
    }
}

print "finished\n\n" if $DEBUG;
