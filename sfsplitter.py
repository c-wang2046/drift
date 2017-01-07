import argparse
import pyfits
parser=argparse.ArgumentParser()
parser.add_argument("rawfile")
parser.add_argument("-start",type=int, help="starting row")
parser.add_argument("-end", type=int, help="ending row")
parser.add_argument("output", help="output file")
args=parser.parse_args()
print(args)
start_si=args.start
end_si=args.end
rawfile=args.rawfile
outputfile=args.output

f=pyfits.open(rawfile, memmap=True)
si=f['SUBINT']
si.data=f['SUBINT'].data[start_si:end_si,]
si.header['NAXIS2']=(end_si-start_si)
tmp=[]
n=len(f)
for i in range(n):
    if f[i] != f['SUBINT']:
        tmp.append(f[i])
tmp.append(si)
hdulist=pyfits.HDUList(tmp) 
hdulist.writeto(outputfile)
