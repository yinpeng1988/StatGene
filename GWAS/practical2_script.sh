## Practical 2 script

head -n 4 genstudy_qc.sample
head -n 1 genstudy_qc.gen

snptest -data genstudy_qc.gen genstudy_qc.sample -o genstudy_qc_univariate_add.out -pheno diseased -frequentist 1 -method threshold
head -n 20 genstudy_qc_univariate_add.out
#awk 'NR>11{$1=10;print}' genstudy_qc_univariate_add.out > genstudy_qc_new.out ## for newest version SNPtest v2.5, there are lines of logs in the beginning of output. But bioinf1 use SNPtest v2.4, so we do:
awk 'NR>1{$1=10;print}' genstudy_qc_univariate_add.out > genstudy_qc_new.out
echo "CHR SNP BP P" > genstudy_qc_Manhattan.txt
awk '{print $1,$2,$4,$42}' genstudy_qc_new.out >> genstudy_qc_Manhattan.txt
awk '$9==1{print $2}' genstudy_qc_univariate_add.out > genstudy_qc.unimp.snp

sh QuickManhattan.sh

awk ' $4 <0.0001'  genstudy_qc_Manhattan.txt > lowest_ps_univariate
awk '$4>0'  lowest_ps_univariate > lowest_ps_univariate_new

# Rscript univariate_assoc_test.R
#cat univariate_assoc_pvalue.txt

snptest -data genstudy_qc.gen genstudy_qc.sample -o genstudy_qc_adjusted_add.out -pheno diseased -frequentist 1 -method threshold -cov_names age family

head -n 20 genstudy_qc_adjusted_add.out

#awk 'NR>12{$1=10;print}' genstudy_qc_adjusted_add.out > genstudy_qc_adj_new.out # same reason as the explanation above
awk 'NR>1{$1=10;print}' genstudy_qc_adjusted_add.out > genstudy_qc_adj_new.out
echo "CHR SNP BP P" > genstudy_qc_adj_Manhattan.txt
awk '{print $1,$2,$4,$42}' genstudy_qc_adj_new.out >> genstudy_qc_adj_Manhattan.txt

awk '$4 <0.0001'  genstudy_qc_adj_Manhattan.txt > lowest_ps_adjusted
awk '$4>0'  lowest_ps_adjusted > lowest_ps_adjusted_new
          
sh QuickManhattan.sh # SNPtest output file name: genstudy_qc_adj_Manhattan.txt


