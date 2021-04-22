module load bcftools vcftools

#this is the file that has both invariant and variant sites
VCF=05_INCLUDE_INVARIANTS/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_SNPs_INV_fil_setGT_PASS.vcf.gz

#make a file that is only invariant sites with max missing data of 0.5
#max alleles 1 neccessary otherwise triallelic are included
vcftools --gzvcf $VCF \
--max-maf 0 \
--max-missing 0.50 \
--max-alleles 1 \
--recode --stdout | bgzip -c > 05_INCLUDE_INVARIANTS/INVARIANT_ONLY/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_INVARIANT.vcf.gz

tabix 05_INCLUDE_INVARIANTS/INVARIANT_ONLY/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_INVARIANT.vcf.gz

#this is your invariant site file
VCF=05_INCLUDE_INVARIANTS/INVARIANT_ONLY/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_INVARIANT.vcf.gz
#this is a snp file
VCF_SNPS=/home/eenbody/snic2020-2-19/private/wagtail/variants/07_BIALLELIC_ONLY/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_SNPs_fil_setGT_PASS_BIALLELIC.vcf.gz

mkdir -p 05_INCLUDE_INVARIANTS/INV_PLUS_BIAL

#flag for removing duplicates probably not neccessary, but solved some problems I had at one point with this method
bcftools concat \
--allow-overlaps \
--rm-dups all \
$VCF_SNPS $VCF \
-O z -o 05_INCLUDE_INVARIANTS/INV_PLUS_BIAL/wagtails_sentieon_${SLURM_ARRAY_TASK_ID}_INV_BIALLELIC.vcf.gz
