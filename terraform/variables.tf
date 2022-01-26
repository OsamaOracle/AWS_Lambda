variable "region"{
type = string
}

variable "accountId"{
type = string
}

variable "rest_api"{
type = string
}

variable "resource_name"{
type = string
}

variable "code_path"{
type = string
}

variable "http_methods"{
  type    = list(string)
}
