resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.eu-west-2.s3"

  tags = {
    Environment = "test"
  }
}