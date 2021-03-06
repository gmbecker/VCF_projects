test_filterVcf_TabixFile <- function()
{
    fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
    tbx <- TabixFile(fl, yieldSize=5000)
    dest <- tempfile()
    filt <- FilterRules(list(fun=function(...) TRUE))
    ans <- filterVcf(tbx, "hg19", dest, filters=filt)
    
    checkIdentical(dest, ans)
    vcf0 <- readVcf(fl, "hg19")
    vcf1 <- readVcf(dest, "hg19")
    checkIdentical(dim(vcf0), dim(vcf1))
}

test_filterVcf_filter <- function()
{
    fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
    tbx <- TabixFile(fl, yieldSize=5000)

    filt <- FilterRules(list(filt1=function(x) {
        rowSums(geno(x)$DS > 0.5) > 0
    }))
    dest <- tempfile()

    ans <- filterVcf(tbx, "hg19", dest, filters=filt)
    vcf0 <- subsetByFilter(readVcf(fl, "hg19"), filt)
    vcf1 <- readVcf(ans, "hg19")
    checkIdentical(dim(vcf0), dim(vcf1))
}
