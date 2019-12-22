resource "aws_s3_bucket" "shakeel-bucket" {
  bucket        = "shakeel-2-test"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "shakeel-bucket_notification" {
  bucket = "${aws_s3_bucket.shakeel-bucket.id}"

  topic {
    topic_arn = "${aws_sns_topic.shakeel-sns.arn}"
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sqs_queue" "shakeel-queue" {
  provider                  = "aws.terra-sqs"
  name                      = "test-sqs"
  delay_seconds             = 90
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "test"
  }

  policy = <<POLICY
{
  "Id": "Policy1576344185488",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1576344184264",
      "Action": "sqs:*",
      "Effect": "Allow",
      "Resource": "arn:aws:sqs:us-east-1:ACCOUNT-B:test-sqs",
      "Principal": {
        "AWS": [
          "ACCOUNT-A"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic" "shakeel-sns" {
  name = "notify-test"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": [{"SNS:Publish","SNS:Subscribe"}]
        "Resource": "arn:aws:sns:*:*:notify-test",
        "Condition":{
            "ArnEquals":{"aws:SourceArn":"${aws_s3_bucket.shakeel-bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_sns_topic_subscription" "shakeel-sub" {
  topic_arn = "${aws_sns_topic.shakeel-sns.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.shakeel-queue.arn}"
}
