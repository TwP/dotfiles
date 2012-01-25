#! /usr/bin/python
#
# merge
#   Merge pages from two PDF files into a single PDF file.
#
#   If you have a single-sided scanner with a sheet feeder, you can imagine
#   scanning in a set of double sided pages and producing a PDF file. This
#   file will contain all the odd numbered pages (1,3,5...). Flipping the
#   stack of papers over and scanning the reverse sides will produce a second
#   PDF file containing the even numbered pages in reverse order (...6,4,2).
#   This script will merge these two files and generate a single PDF file with
#   the pages interleaved in the correct order.
#
#   The first PDF file passed to the script is assumed to be the odd nubmered
#   pages. The second PDF file is assumed to be the even numbered pages;
#   furthermore, it is assumed the even pages are in reverse order.
#
#   The merge is performed by taking the first odd page and appending it to
#   the output PDF file followed by the last even page. The next odd page is
#   appeneded followed by the second-to-last even page. This pattern continues
#   until all pages have been appended to the output file.
#
#   merge [--output <file>] [--verbose] oddPages.pdf evenPages.pdf
#
#   Parameter:
#
#   --verbose
#   Write information about the doings of this tool to stderr.
#
import sys
import os
import getopt
import tempfile
import shutil
from CoreFoundation import *
from Quartz.CoreGraphics import *

verbose = False

def createPDFDocumentWithPath(path):
	global verbose
	if verbose:
		print "Creating PDF document from file %s" % (path)
	return CGPDFDocumentCreateWithURL(CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, path, len(path), False))

def writePageFromDoc(writeContext, doc, pageNum):
	global verbose
	page = CGPDFDocumentGetPage(doc, pageNum)
	if page:
		mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox)
		if CGRectIsEmpty(mediaBox):
			mediaBox = None

		CGContextBeginPage(writeContext, mediaBox)
		CGContextDrawPDFPage(writeContext, page)
		CGContextEndPage(writeContext)
		if verbose:
			print "Copied page %d from %s" % (pageNum, doc)

def shufflePages(writeContext, odd, even):
	oddPageCount = CGPDFDocumentGetNumberOfPages(odd)
	evenPageCount = CGPDFDocumentGetNumberOfPages(even) + 1

	for pageNum in xrange(1, oddPageCount + 1):
		writePageFromDoc(writeContext, odd, pageNum)
		writePageFromDoc(writeContext, even, evenPageCount - pageNum)

def main(argv):

	global verbose

	# The PDF context we will draw into to create a new PDF
	writeContext = None

	# If True then generate more verbose information
	source = None

	# Parse the command line options
	try:
		options, args = getopt.getopt(argv, "o:v", ["output=", "verbose"])

	except getopt.GetoptError:
		usage()
		sys.exit(2)

	if len(args) != 2 :
		print "Exactly two PDF documents must be supplied."
		usage()
		sys.exit(2)

	for option, arg in options:

		if option in ("-o", "--output") :
			if verbose:
				print "Setting %s as the destination." % (arg)
			writeContext = CGPDFContextCreateWithURL(CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, arg, len(arg), False), None, None)

		elif option in ("-v", "--verbose") :
			print "Verbose mode enabled."
			verbose = True

		else :
			print "Unknown argument: %s" % (option)

	if writeContext:
		# create PDFDocuments for all of the files.
		odd, even = map(createPDFDocumentWithPath, args)

		# interleave the pages together starting with the odd pages
		# and pulling the even pages in reverse order
		shufflePages(writeContext, odd, even)

		CGPDFContextClose(writeContext)
		del writeContext
		#CGContextRelease(writeContext)

def usage():
	print "Usage: merge [--output <file>] [--verbose] oddPages.pdf evenPages.pdf"

if __name__ == "__main__":
	main(sys.argv[1:])

