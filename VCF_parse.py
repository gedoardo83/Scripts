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

def parseGENOS(samples,format_field,genos_fields):
    genos = {}
    labels = format_field.split(":")
    for v in range(0,len(genos_fields)):
        genos[samples[v]] = {}
        values = genos_fields[v].split(":")
        for f in range(0,len(values)):
            genos[samples[v]][labels[f]] = values[f].rstrip("\n")
    return genos

i = 0
n = 0
with open(filename ,"r") as vcf:
    while True:
        line = vcf.readline()
        if not line.startswith('##'):
            break
        i += 1

    line = line.rstrip("\n")
    fields = line.split("\t")
    samples_ids = fields[9:]

    while line:
        n += 1
        myvar = {}
        fields = line.split("\t")
        idvar = fields[0]+"_"+fields[1]+"_"+fields[3]+"_"+fields[4]
        myvar[idvar] = parseINFO(line)
        myvar[idvar]['genos'] = {}
        myvar[idvar]['genos'] = parseGENOS(samples_ids,fields[8],fields[9:])
        print idvar
        print myvar[idvar]
        line = vcf.readline()

print 'File name:', filename
print 'Skipped ',i,' header lines'
print 'Variants: ', n
