# xtracta_test

#instructions from Jonathan
Test
 
You are given two files invoice.txt and suppliernames.txt. The first
file ( invoice.txt ) contains the words of an invoice (see invoice.pdf)
generated by the OCR engine. Each line has the text of the word
and information about the location of the word in the document. For
example, the line:
 {'pos_id': 1, 'cspan_id': 1, 'rspan_id': 0, 'right': 87.06, 'word':
'INVOICE', 'line_id': 0, 'top': 4.0, 'height': 1.52, 'width': 10.51, 'left':
76.55, 'page_id': 1, 'word_id': 1}
contains the word 'INVOICE', the page it came from (page_id = 1),
the line number (line_id = 6), the position of the word in that line
(pos_id = 0).
You might not need the other information. The second file,
suppliernames.txt, contains a list of supplier names.
The requirement is to find the supplier name of that invoice by
matching the given list of supplier names to the invoice.
Although only a limited number of supplier names are given, make
your solution scalable to hundreds of thousands of supplier names.
You can use the programming language that you prefer.
It is preferred that you submit your solution through GitHub, with
instruction how to run it.
Please do not hesitate to contact us if you have any inquiry.
Good Luck 

==========================================================================

Instructions to run:
Run on linux with perl installed.
Put the perl script and the 2 input files (invoice.txt and suppliernames.txt) in the same directory.
execute the perl script (has debug option -d for progress output)

Example run:
------------------------------------------------------------------------------------------------------
dyoung-ua@fbcord01l (xtracta) ~/sites/site-8030/acnts/ora-scripts/one-offs $ ./xtracta.pl -d
xtracta test

reading input file invoice.txt and decoding json data

extracted json data. process the data and grab info we want which is the words on each line

get supplier data from suppliernames.txt

matching supplier data with words on a line to match supplier to invoice data

#############
matched supplier Demo Company (id 3153303). Found on page 1 line 4
#############

--------------------------------------------------------------------------------------------------------



=====================
Build notes
=====================
sat 12:23pm start

=====================
solution design
------------------
get the data of the invoice words which contain the supplier name.
get the data of all supplier names
match each supplier name with each line of words from the invoice

have to merge the words for each line in the invoice file.
once has a line then can use that to match the supplier.
The matching approach would be to join the supplier names together without spaces and to join the invoice words in a line together.
that should give us the data from both dataset that would create a match.

There can be exeption scenarios I presume. Will look into that once get the basic solution done to refine/adjust the detailed solution approach.

After basic solution and/or refined solution is complete. look at the scalability of it.
shouldn't be a huge problem for a single run but if throughput performance is required then likely need some eliquant elaquaint solution
=======================

Read the files.
invoices.txt - json file. read the file and store the data to be manipulated and processed for matching

learning json syntax and perl parser.

invoice.txt is not valid json format. strings need to be double quoted.

looked at reading the whole file in vs each line.
had issue with the file not being correct json format so left this part commented out for future

suppliernames.txt - csv file. read and store in hash to be used for string manipulation and matching

get data from the json
put into data structure that would be useful. hash of hashes/arrays

page(id) -> line(id) -> word and position
man took awhile to get the data structure syntax right lol.
Now I have all the words on a page for each line in an arrary.


discovered the PDF doesn't match the invoice.txt json data. ??
nvm was just the ordering of the line numbers where 1-9 don't have leading zeros and 11-19 ordered before 2-9

The OCR can't seen to read 'Notes'/'notes' or 'Note'/'note' correctly. The json data has 'Noel' where I expect 'Notes' to be
other OCR recognition is not reliable. accuracy deteriorates in certain aspects or resolution, as to be expected.

loop through each line of words
join the words together with a space (or not space or whatever if desired)
check the joined line against each supplier and see if there is a match

#####DONE###### approx sat 4:45pm
Fully functional script completed. little over 4 hours, should've taken 2. bit rusty from not coding and had to learn syntax for json

==================================================================

sunday 6:34pm
--------------------------------
plan:
tidy up code.
signup to GitHub
perl tidy code
perl critic code
write documentation

half hour to do GitHub signup and intro

looked briefly at perl critic
fixed filehandle usages
tried to fix open->close file handle space but its too fussy on it.

tidied up code, removed excess debugging. put some progress debugging
added more comments espcially about scalability:
#One of the requirements is to make this script scalable to hundreds of thousands of suppliers.
#This will read the entire supplier file into memory to do the matching against the lines of words
#The list of suppliers would be small even at hundreds of thousands of records and won't cause probelms memory wise.
#This is my main approach with the focus on speed of processing.
#If memory is a limitation we could look at reading each supplier 1 at a time and doing the comparison.
#This will be slower processing wise but is more memory efficient.

finished about 8pm. 1 and half hours.

upload and submit to GitHub



