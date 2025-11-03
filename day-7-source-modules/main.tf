module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "abhipsa-s3-bucket-03-11-2025"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  #versioning = {
   # enabled = true
  #}
}