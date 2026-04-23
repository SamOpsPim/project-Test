locals {
  allocation_tags = merge(
    {
      Environment = var.cost_allocation_tags.Environment
      Project     = var.cost_allocation_tags.Project
      Owner       = var.cost_allocation_tags.Owner
      CostCenter  = var.cost_allocation_tags.CostCenter
    },
    var.extra_tags
  )
}
