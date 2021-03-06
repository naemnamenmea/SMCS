# potentialFunc <- function(xl,u,h,charge,metricFunction = euclideanDistance)
# {#не работает почему-то ((
#   l <- dim(xl)[1]
#   n <- dim(xl)[2]-1
#   distances <- matrix(NA, l, 2)
#   for (i in 1:l)
#   {
#     distances[i, ] <- c(i, metricFunction(xl[i, 1:n], u))
#   }
#   orderedXl <- xl[order(distances[, 2]), ]
#   classesList <- unique(xl[ ,n+1])
#   clLength <- length(classesList)
#   counts <- rep(0,clLength)
#   for (i in 1:l)
#   {
#     counts[which(orderedXl[i,n+1]==classesList)] <- 
#       counts[which(orderedXl[i,n+1]==classesList)] +
#       charge[i]*kerne(distances[i, 2]/h,ker.type[7])
#   }
#   as.character(classesList[which.max(counts)])
# }

potentialFunc <- function(xl, x, h, gammaV){
  distances <- c()
  wght_to_class <- c()
  for(i in 1:nrow(xl)){
    distances[i] <- euclideanDistance(xl[i , -ncol(xl)] , x)
    wght_to_class[i] <- kerne(distances[i] / h[i], ker.type[7]) * gammaV[i]  
  }
  
  potentional_wght <- data.frame(p_class <- xl$Species, wght_to_class)
  wght_max <- c( sum_setosa <- sum(potentional_wght[potentional_wght$p_class == "setosa" , 2]),
                 sum_versicolor <- sum(potentional_wght[potentional_wght$p_class == "versicolor" , 2]),
                 sum_virginica <- sum(potentional_wght[potentional_wght$p_class == "virginica" , 2]) )
  if(sum(wght_max) == 0){
    
    res <- ""
  }else{
    res <- levels(xl$Species)[match(max(wght_max), wght_max)]
  }
  return(res)
}

getBestGamma <- function(xl, h, eps) {
  gammaV <- rep(0, nrow(xl))
  i <- 1
  while(loo_potential(xl, h, gammaV) > eps) {
    n <- dim(xl)[2]
    # i <- sample(1:nrow(xl), 1)
    if(potentialFunc(xl, xl[i, -n], h, gammaV) != xl[i, n]) {
      gammaV[i] <-  gammaV[i] + 1
    }
    i <- i + 1
    if(i>nrow(xl)) i <- 1
  }
  return(gammaV) 
}

# optimizedCharge <- function(xl,eps,h)
# {
#   l <- dim(xl)[1]
#   n <- dim(xl)[2]-1
#   charge <- rep(0,l)
#   while(TRUE)
#   {
#     mistakes <- 0
#     for(i in 1:l)
#     {
#       if(potentialFunc(xl,xl[i, 1:n],h,charge)!=xl[i,n+1])
#       {
#         mistakes <- mistakes+1
#         charge[i] <- charge[i]+1
#       }
#     }
#     if(mistakes/l<eps) break
#   }
#   return(charge)
# }

#potentialFunc(xl,c(6.5,2),rep(1,150),rep(10,150))
#vec <- optimizedCharge(xl,0.1,1)
#vec