% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/changepoint_gibbs_2cp_v2.R
\name{runmcmc_cp2}
\alias{runmcmc_cp2}
\title{Estimate a posterior distribution of data conditional that there are two grooves.}
\usage{
runmcmc_cp2(data, iter, start.vals, prop_var, cp_prop_var, tol_edge = 50,
  tol_cp = 1000, warmup = 500, verbose = FALSE)
}
\arguments{
\item{data}{Data frame with columns "x" and "y." "x" is a column of the locations of the
observed residual values, y.}

\item{iter}{Number of interations after warmup.}

\item{start.vals}{Starting values for the changepoint algorithm.
List with elements "sigma", "l", "cp", "beta", and "intercept." "sigma" and "l"
  are 3 element vectors where the first element is for the data on the left groove.
  The second element is for the land engraved area, and the third element is for the right groove.
  "cp" is the vector of changepoint starting values. "beta" and "intercept" are two element vectors
  of the slope and intercept for the left and right groove engraved area respectively.}

\item{prop_var}{A three element list of the proposal variance-covariance matrices for the random
walk Metropolis algorithm(s). The first element is for the left groove engraved area.
The second element is for the land engraved area, and the third element is for the right engraved area.}

\item{cp_prop_var}{The proposal variance-covariance matrix for the changepoints.}

\item{tol_edge}{This parameter controls how close changepoint proposals can be to the edge of the data
before getting automatically rejected. For example, a value of 10 means that the changepoint will be
automatically rejected if either of the proposal changepoints is within a distance of 10 x-values from either edge.}

\item{tol_cp}{This parameter controls how close changepoint proposals can be to each other
before getting automatically rejected. For example, a value of 10 means that the changepoint will be
automatically rejected if either of the proposal changepoints is within a distance of 10 x-values from either each other.}

\item{warmup}{The number of initial iterations which serves two purposes: the first is to allow the
algorithm to wander to the area of most mass, and the second is to tune the proposal variance.}

\item{verbose}{Logical value indicating whether to print the iteration number and the parameter proposals.}
}
\value{
A named list containing the sampled parameters, acceptance rates for the Metropolis steps,
log likelihood values, and proposal variance for the changepoints.
}
\description{
This function runs a random walk metropolis within Gibbs algorithm to estimate the posterior distribution
of the value of the changepoints as well as the parameters fit in each multivariate normal distribution
on either side of each changepoint. The covariance matrices are based on the exponential covariance function.
This functions assumes equally spaced locations ("x" values in the "data" argument). The distribution
to the right of the right most changepoint and to the left of the left most changepoint have
means that are a linear function of the distance from the center of the data. The slope is
constrained to be negative in the left case and positive in the right case. The models fit
to the groove engraved areas are exactly the same as in the one changepoint case. Thus, this algorithm
only differs in that there are three segments of data to deal with as opposed to two.
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

# define starting values for the changepoints
cp_start_left <- min(fake_groove$x) + 60
cp_start_right <- max(fake_groove$x) - 60

# define starting values
start.vals <- list("sigma" = c(1,1,1),
                "l" = c(10,10,10),
                "cp" = c(cp_start_left, cp_start_right),
                "beta" = c(-2,2),
                "intercept" = c(0,0))

# define proposal variances (not for changepoints)
prop_var <- list(diag(c(1/2,1/2,1/2,1/2)),
              diag(c(1/2,1/2)),
              diag(c(1/2,1/2,1/2,1/2)))

# define proposal variance for changepoints
cp_prop_var <- diag(c(10^2, 10^2))


# run Gibbs MCMC for both the right only and left only GEA models
set.seed(1111)
m2cp <- runmcmc_cp2(data = fake_groove,
                 iter = 500,
                 start.vals = start.vals,
                 prop_var = prop_var,
                 cp_prop_var = cp_prop_var,
                 tol_edge = 50, tol_cp = 1000,
                 warmup = 100,
                 verbose = FALSE)
}
