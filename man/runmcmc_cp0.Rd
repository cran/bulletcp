% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/changepoint_gibbs_0cp.R
\name{runmcmc_cp0}
\alias{runmcmc_cp0}
\title{Estimate a posterior distribution of data conditional on zero changepoints.}
\usage{
runmcmc_cp0(data, iter, start.vals, prop_var, warmup = 500,
  verbose = FALSE)
}
\arguments{
\item{data}{Data frame with columns "x" and "y." "x" is a column of the locations of the
observed residual values, y.}

\item{iter}{Number of interations after warmup.}

\item{start.vals}{List with elements "sigma" and "l" for the standard deviation and length scale
which parameterize the covariance matrix.}

\item{prop_var}{The proposal variance-covariance matrix for the random walk metropolis algorithm.}

\item{warmup}{The number of initial iterations which serves two purposes: the first is to allow the
algorithm to wander to the area of most mass, and the second is to tune the proposal variance.}

\item{verbose}{Logical value indicating whether to print the iteration number and the parameter proposals.}
}
\value{
A named list. "parameters" is a list of named parameter values each of which is a vector of length
"iter". "accept" gives the proportion of accepted proposals after warmup. "lp" is a vector of
values of the log data pdf at each sampled parameter value.
}
\description{
This function runs a random walk Metropolis algorithm to estimate the posterior distribution
of a zero mean multivariate normal distribution with an covariance matrix generated by the
exponential covariance function. This functions assumes equally spaced locations ("x" values in the
"data" argument).
}
\examples{
# Fake data
sim_groove <- function(beta = c(-0.28,0.28), a = 125)
{
    x <- seq(from = 0, to = 2158, by = 20)
    med <- median(x)
    y <- 1*(x <= a)*(beta[1]*(x - med) - beta[1]*(a - med)) +
    1*(x >= 2158 - a)*(beta[2]*(x - med) - beta[2]*(2158 - a - med))
    return(data.frame("x" = x, "y" = y))
}

fake_groove <- sim_groove()
# define starting values
start.vals <- list("sigma" = c(1), "l" = c(10))

# proposal variance for the MH step
prop_var <- diag(c(1/2,1/2))

set.seed(1111)
m0cp <- runmcmc_cp0(data = fake_groove, iter = 500,
    start.vals = start.vals,
    prop_var = prop_var, warmup = 100, verbose = FALSE)
}
