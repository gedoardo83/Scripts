//Take a bim file with SNP id in form of chr:pos and convert to rsID using dbSNP VCF file
//dbSNP VCF file must be normalized and without header lines

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <map>
#include <boost/algorithm/string.hpp>
using namespace std;
using namespace boost;

map< string, string > elements;
typedef vector< string > split_vector_type;

int main(int argc, char** argv)
{
clock_t begin = clock();

string infile1 = "";
infile1 = argv[1];

string infile2 = "";
infile2 = argv[2];

cout << "file 1:" << infile1 << endl;
cout << "file 2:" << infile2 << endl;

//Read file 1 - dbSNP VCF file
ifstream file(infile1.c_str());
string line;
while(getline(file, line))
{
        split_vector_type SplitVec;
        split(SplitVec, line, is_any_of("\t"));

        //create snpid (chr:pos_ref_alt) and snpid1 (chr:pos_alt_ref)
        //In this way can match bim snps even if a1/a2 are flipped compared to ref/alt
        string snpid = SplitVec[0] + ":" + SplitVec[1] + "_" + SplitVec[3] + "_" + SplitVec[4];
        string snpid1 = SplitVec[0] + ":" + SplitVec[1] + "_" + SplitVec[4] + "_" + SplitVec[3];
        
        //save rsid for each snpid
        elements[snpid] = SplitVec[2];
        elements[snpid1] = SplitVec[2];
}

//Read file 2 - bim file
ifstream file2(infile2.c_str());

while(getline(file2, line))
{
    split_vector_type SplitVec;
    split(SplitVec, line, is_any_of("\t"));

    //create snp id chr:pos_ref_alt
    string snpid = SplitVec[0] + ":" + SplitVec[3] + "_" + SplitVec[4] + "_" + SplitVec[5];

    //print bim with snp_id converted to rsid, if no rsid exists print the original line
    if (elements.count(snpid) > 0) {
       cout << SplitVec[0] << "\t" <<  elements[snpid] << "\t" << SplitVec[2] << "\t" << SplitVec[3] << "\t" << SplitVec[4] << "\t" << SplitVec[5] << endl;
    } else {
       cout << line << endl;
    }
}

//clock_t end = clock();
//double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
//cout << "Total run time: " << time_spent << endl;
return 0;
}
