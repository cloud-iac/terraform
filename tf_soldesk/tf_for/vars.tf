variable "users" {
  default = [
    {
        name = "kim"
        level = 1
        role = "회계"
        is_dev = false
    },
    {
        name = "lee"
        level = 5
        role = "개발자"
        is_dev = true
    },
    {
        name = "park"
        level = 10
        role = "사장님"
        is_dev = true
    },
  ]
}