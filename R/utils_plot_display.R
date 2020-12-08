#-- This controls the making of the plots
#' @import ggplot2

globalVariables(c("user_factor"))
point_plot <- function(data, xcol, ycol, size, type, user_colour, 
                       x_axis_label, x_axis_rotation,
                       y_axis_label, y_axis_rotation,
                       plot_title, plot_title_position, 
                       legend_position) {
  
  validate(need(xcol != "None", message = "Select a x column"))
  validate(need(ycol != "None", message = "Select a y column" ))
  
  #-- base plot
  p <- ggplot(data, aes_string(xcol, ycol)) +
    ggtitle(label = plot_title) +
    theme_classic() +
    xlab(x_axis_label) + ylab(y_axis_label) +
    theme(axis.text.x = element_text(angle = x_axis_rotation, hjust = 1),
          axis.text.y = element_text(angle = y_axis_rotation, hjust = 1),
          plot.title = element_text(hjust = plot_title_position))
    
  #-- assign points based on factor
  if (length(user_colour) == 1) {
    p <- p +
      geom_point(shape = as.numeric(type), size = as.numeric(size), fill = user_colour) 
    
  } else {
   p <- p + 
     geom_point(shape = as.numeric(type), size = as.numeric(size), aes(fill = user_factor)) +
     labs(fill = NULL) +
     scale_fill_manual(values = user_colour) +
     theme(legend.position = legend_position)
  }
  
  return(p)
}

bar_plot <- function(data, xcol, ycol, user_colour, 
                     x_axis_label, x_axis_rotation,
                     y_axis_label, y_axis_rotation,
                     plot_title, plot_title_position, 
                     legend_position) {
  
  validate(need(xcol != "None", message = "Select a x column"))
  
  if (ycol == "None") {
    p <- ggplot(data, aes_string(xcol))
    
      if (length(user_colour) == 1) {
        p <- p + 
          geom_bar(fill = user_colour)
      # -- two colours
      } else {
        p <- p +
          geom_bar(aes_string(fill = user_factor)) +
          scale_fill_manual(values = user_colour)
      }  

  } else {
    p <- ggplot(data, aes_string(xcol, ycol))
    
    if (length(user_colour) == 1) {
      p <- p + 
        geom_bar(stat = "identity", fill = user_colour)
      # -- two colours
    } else {
      p <- p +
        geom_bar(stat = "identity", position = "dodge",
                 aes_string(fill = user_factor)) +
        scale_fill_manual(values = user_colour)
    } 
  }
    
    #-- common additions
    p <- p +
      xlab(x_axis_label) + ylab(y_axis_label) + labs(fill = NULL) +
      ggtitle(plot_title) +
      theme_classic() +
      theme(axis.text.x = element_text(angle = x_axis_rotation, hjust = 1),
            axis.text.y = element_text(angle = y_axis_rotation, hjust = 1),
            plot.title = element_text(hjust = plot_title_position),
            legend.position = legend_position)
    
    return(p)
  
}

box_plot <- function(data, xcol, ycol, user_colour, 
                     x_axis_label, x_axis_rotation,
                     y_axis_label, y_axis_rotation,
                     plot_title, plot_title_position, 
                     size, type,
                     legend_position) {
  
  validate(need(xcol != "None", message = "Select a x column"))
  
  if (ycol == "None") {
    p <- ggplot(data, aes_string(xcol))
    if (length(user_colour) == 1) {
      p <- p +
        geom_boxplot(fill = user_colour, outlier.size = as.numeric(size), outlier.shape = as.numeric(type))
    # -- two colours
    } else {
      p <- p +
        geom_boxplot(aes(fill = user_factor), outlier.size = as.numeric(size), outlier.shape = as.numeric(type)) +
        scale_fill_manual(values = user_colour)
    }
  # -- two columns chosen
  } else {
    p <- ggplot(data, aes_string(xcol, ycol))
  
    if (length(user_colour) == 1) {
      p <- p + 
        geom_boxplot(fill = user_colour, outlier.size = as.numeric(size), outlier.shape = as.numeric(type))
    } else {
      p <- p +
        geom_boxplot(aes(fill = user_factor), outlier.size = as.numeric(size), outlier.shape = as.numeric(type)) +
        scale_fill_manual(values = user_colour)
    }
  }
  
  #-- common additions
  p <- p +
    xlab(x_axis_label) + ylab(y_axis_label) + labs(fill = NULL) +
    ggtitle(plot_title) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = x_axis_rotation, hjust = 1),
          axis.text.y = element_text(angle = y_axis_rotation, hjust = 1),
          plot.title = element_text(hjust = plot_title_position),
          legend.position = legend_position)
  
  return(p)
}

density_plot <- function(data, xcol, ycol, user_colour, 
                         x_axis_label, x_axis_rotation,
                         y_axis_label, y_axis_rotation,
                         plot_title, plot_title_position, 
                         legend_position) {
  
  validate(need(xcol != "None", message = "Select a x column"))
  
  if (ycol == "None") {
    p <- ggplot(data, aes_string(xcol))
    if (length(user_colour) == 1) {
      p <- p +
        geom_density(fill = user_colour)
      # -- two colours
    } else {
      p <- p +
        geom_density(aes(fill = user_factor)) +
        scale_fill_manual(values = user_colour)
    }
    # -- two columns chosen
  } else {
    p <- ggplot(data, aes_string(xcol, ycol))
    
    if (length(user_colour) == 1) {
      p <- p +
        geom_density(stat = "identity", fill = user_colour)
      # -- two colours
    } else {
      p <- p +
        geom_density(stat = "identity", aes(fill = user_factor)) +
        scale_fill_manual(values = user_colour)
    }
  }
  
  #-- common additions
  p <- p +
    xlab(x_axis_label) + ylab(y_axis_label) + labs(fill = NULL) +
    ggtitle(plot_title) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = x_axis_rotation, hjust = 1),
          axis.text.y = element_text(angle = y_axis_rotation, hjust = 1),
          plot.title = element_text(hjust = plot_title_position),
          legend.position = legend_position)
  
  return(p)
}

violin_plot <- function(data, xcol, ycol, user_colour, 
                        x_axis_label, x_axis_rotation,
                        y_axis_label, y_axis_rotation,
                        plot_title, plot_title_position, 
                        legend_position) {
  
  validate(need(xcol != "None", message = "Select a x column"))
  validate(need(ycol != "None", message = "Select a y column" ))
  
  p <- ggplot(data = data, aes_string(xcol, ycol))
  
  if (length(user_colour) == 1) {
    p <- p +
      geom_violin(fill = user_colour)
  } else {
    p <- p +
      geom_violin(aes(fill = user_factor)) +
      scale_fill_manual(values = user_colour)
  }
  
  #-- common additions
  p <- p +
    xlab(x_axis_label) + ylab(y_axis_label) + labs(fill = NULL) +
    ggtitle(plot_title) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = x_axis_rotation, hjust = 1),
          axis.text.y = element_text(angle = y_axis_rotation, hjust = 1),
          plot.title = element_text(hjust = plot_title_position),
          legend.position = legend_position)
  
  return(p)
}