library(genalg)
library(ggplot2)

dataset <- data.frame(
	item = c("pocketknife", "beans", "potatoes", "unions", "sleeping bag", "rope", "compass"), 
	survivalpoints = c(10, 20, 15, 2, 30, 10, 20),
	weight = c(1, 5, 10, 1, 7, 5, 1))
weightlimit <- 20

evalFunc <- function(x) {
	current_solution_survivalpoints <- x %*% dataset$survivalpoints
	current_solution_weight <- x %*% dataset$weight

	if(current_solution_weight > weightlimit)
		return(0)
	else
		return(-current_solution_survivalpoints)
}

iter <- 100

GAmodel <- rbga.bin(
	size = 7,
	popSize = 200,
	iters = iter,
	mutationChance = 0.01,
	elitism = T,
	evalFunc = evalFunc)

cat(summary.rbga(GAmodel))

# Visualization

animate_plot <- function(x) {
	for(i in seq(1, iter)) {
		temp <- data.frame(
			Generation = c(seq(1, i), seq(1, i)), 
			Variable = c(rep("mean", i), rep("best", i)),
			Survivalpoints = c(-GAmodel$mean[1:i], -GAmodel$best[1:i]))
		
		pl <- 
			ggplot(
				temp, 
				aes(
					x = Generation, 
					y = Survivalpoints, 
					group = Variable, 
					colour = Variable)) + 
			geom_line() + 
			scale_x_continuous(
				limits = c(0, iter)) + 
			scale_y_continuous(
				limits = c(0, 110)) + 
			geom_hline(
				y = max(temp$Survivalpoints), 
				lty = 2) + 
			annotate(
				"text", 
				x = 1, 
				y = max(
					temp$Survivalpoints) + 2, 
				hjust = 0, 
				size = 3, 
				color = "black", 
				label = paste("Best solution:", max(temp$Survivalpoints))) + 
			scale_colour_brewer(palette = "Set1") + 
			opts(title = "Evaluation Knapsack optimization model")
		print(pl)
	}
}

#Save animation
library(animation)
saveMovie(animate_plot(), interval = 0.1, outdir = getwd())
