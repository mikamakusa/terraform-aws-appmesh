module "acm" {
  source                                   = "./modules/terraform-aws-acm"
  acmpca_certificate_authority             = var.acmpca_certificate_authority
  acmpca_certificate                       = var.acmpca_certificate
  acmpca_certificate_authority_certificate = var.acmpca_certificate_authority_certificate
}