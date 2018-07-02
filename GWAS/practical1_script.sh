#bioinf_setup ## the set up for lxa.liv.ac.uk
#cp /tmp/course/* ./


# 1.login in bioinf1.liv.ac.uk
# 2. You'd better make your own directory and copy all the files over from /ph-users/shared/workshop/*
# 3. qrsh # access to a computing node
# 4. cd your_working_directory

ls -l genstudy*
awk 'FNR == 1 { print $1,$2,$3,$4,$5,$6,$7,$8} ' genstudy.ped
head -n 2 genstudy.map
plink --file genstudy --chr 10 --noweb
cat plink.log
plink --file genstudy --make-bed --out genstudy --noweb
plink --bfile genstudy --chr 10 --noweb
plink --bfile genstudy --missing --out genstudy.CRstats --noweb
head -n 10 genstudy.CRstats.imiss
plink --bfile genstudy --check-sex --out genstudy --noweb
head -n 20  genstudy.sexcheck
plink --bfile genstudy --indep-pairwise 1500 150 0.2 --noweb
plink --bfile genstudy --extract plink.prune.in --make-bed --out p.genstudy --noweb
plink --bfile p.genstudy --genome --out genstudy --noweb
head -5 genstudy.genome
plink --bfile p.genstudy --het --out genstudy --noweb
head -5 genstudy.het

Rscript QC_plot.R

awk 'NR>1 && $6 >= 0.05 {print}' genstudy.CRstats.imiss | wc -l
awk '$6 >= 0.05 {print}' genstudy.CRstats.imiss > genstudy.CRremove
cat genstudy.CRremove
plink --bfile genstudy --noweb --remove genstudy.CRremove --make-bed --out genstudy.CR
awk '$5=="PROBLEM"{print}' genstudy.sexcheck>genstudy.sexremove
cat genstudy.sexremove
plink --bfile genstudy.CR --noweb --remove genstudy.sexremove --make-bed --out genstudy.sex
awk '$10 >= 0.1875 {print}' genstudy.genome > genstudy.PIremove
cat genstudy.PIremove
echo "FID   IID
idR_250 idR_250
idR_251 idR_251
idD_252 idD_252
idD_253 idD_253" > genstudy.PIremove.list
plink --bfile genstudy.sex --noweb --remove genstudy.PIremove.list --make-bed --out genstudy_sampleqc

# SNP qc
plink --bfile genstudy_sampleqc --missing --out genstudy_sampleqc.CRstats --noweb
awk 'NR>1 && $5 >= 0.05 {print}' genstudy_sampleqc.CRstats.lmiss | wc -l
plink --bfile genstudy_sampleqc --noweb --freq --out genstudy_sampleqc
awk '$5<0.05' genstudy_sampleqc.frq | wc -l
plink --bfile genstudy_sampleqc --noweb --hardy --out genstudy_sampleqc
awk '$3=="UNAFF" && $9<0.0001' genstudy_sampleqc.hwe | wc -l
plink --bfile genstudy_sampleqc --noweb --maf 0.05 --geno 0.05 --hwe 0.0001 --make-bed --out genstudy_qc


