shapeit --input-ped genstudy_pp.ped genstudy_pp.map --input-map chr10.map --output-max genstudy.ph --thread 8 --input-from 63000000 --input-to 68000000
impute -use_prephased_g -known_haps_g genstudy.ph.haps -m chr10.map -h chr10.haps.gz -l chr10.leg.gz -int 64300000 65300000 -Ne 20000 -buffer 500 -o genstudy_imp.gen
snptest -data genstudy_imp.gen genstudy_qc.sample -o genstudy_qc_univariate_add.imp.out -pheno diseased -frequentist 1 -method threshold
#awk 'NR>11&&$9>0.4{$1=10;print}' genstudy_qc_univariate_add.imp.out >genstudy_qc_new.imp.out # for SNPTEST v2.5 output
awk 'NR>1&&$9>0.4{$1=10;print}' genstudy_qc_univariate_add.imp.out >genstudy_qc_new.imp.out # for SNPTEST v2.4 output
echo "CHR SNP BP P" > genstudy_qc_Manhattan.imp.txt;
#awk '{print $1,$2,$4,$42}' genstudy_qc_new.imp.out>> genstudy_qc_Manhattan.imp.txt # for SNPTEST v2.5 output
awk '{print $1,$2,$4,$37}' genstudy_qc_new.imp.out>> genstudy_qc_Manhattan.imp.txt # for SNPTEST v2.4 output
awk ' $4 <0.0001&&$4>0'  genstudy_qc_Manhattan.imp.txt > lowest_ps_univariate.imp
awk ' $9==1{print $2}' genstudy_qc_new.imp.out > genstudy_qc.unimp.snp

#awk '$9==1{print $2}' genstudy_qc_univariate_add.out > genstudy_qc.unimp.snp

sh QuickManhattan.sh # genstudy_qc_Manhattan.imp.txt

snptest -data genstudy_imp.gen genstudy_qc.sample -o genstudy_qc_adjusted_add.imp.out -pheno diseased -frequentist 1 -method threshold -cov_names age family
head -n 20 genstudy_qc_adjusted_add.imp.out


#awk 'NR>12&&$9>0.4{$1=10;print}' genstudy_qc_adjusted_add.imp.out >genstudy_qc_adj_new.imp.out
awk 'NR>1&&$9>0.4{$1=10;print}' genstudy_qc_adjusted_add.imp.out >genstudy_qc_adj_new.imp.out

echo "CHR SNP BP P" > genstudy_qc_adj_Manhattan.imp.txt;
#awk '$42>0 && $42!="NA" {print $1,$2,$4,$42}' genstudy_qc_adj_new.imp.out>> genstudy_qc_adj_Manhattan.imp.txt # for SNPTEST v2.5 output
awk '$37>0 && $37!="NA" {print $1,$2,$4,$37}' genstudy_qc_adj_new.imp.out>> genstudy_qc_adj_Manhattan.imp.txt # for SNPtest v2.4 output

awk ' $9==1{print $2}' genstudy_qc_adj_new.imp.out > genstudy_qc.unimp.snp
sh QuickManhattan.sh # genstudy_qc_adj_Manhattan.imp.txt

awk ' $4 <0.0001&&$4>0'  genstudy_qc_adj_Manhattan.imp.txt > lowest_ps_adj.imp



