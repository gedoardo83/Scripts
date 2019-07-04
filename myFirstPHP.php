import sys
import re

filename = sys.argv[1]

def parseINFO(vcfline):
    infos = {}
    fields = vcfline.split("\t")
    values = fields[7].split(";")
    for tag in infos:
        p = re.compile('(.+)=(.+)')
        m = p.match(tag)
        infos[m.group(1)] = m.group(2)
    return infos

def parseGENOS(vcfline):
    genos = {}
    fields = vcfline.split("\t")
    labels = fields[8].split(":")
    values = fields[9].split(":")
    for v in range(0,len(values)):
        genos[labels[v]] = values[v].rstrip("\n")
    return genos

i = 0
n = 0
with open(filename ,"r") as vcf:
    while True:
        line = vcf.readline()
        if not line.startswith('#'):
            break
        i += 1

    while line:
        n += 1
        myvar = {}
        fields = line.split("\t")
        idvar = fields[0]+"_"+fields[1]+"_"+fields[3]+"_"+fields[4]
        myvar[idvar] = parseINFO(line)
        myvar[idvar].update(parseGENOS(line))
        print idvar
        print myvar[idvar]
        line = vcf.readline()

print 'File name:', filename
print 'Skipped ',i,' header lines'
print 'Variants: ', n
