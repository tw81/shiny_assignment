# Create a slider to define the proportion of data which is in the training or test sets
# when a model is fitted for the old faithful data
# Plot the model prediction on the test and training data, and report the errors on the 
# test set


library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("Accuracy of model prediction on a test set for varying sizes of training data"),
    # Sidebar with a slider input for size of training set
    sidebarLayout(
        sidebarPanel(
            sliderInput("train_prop","Adjust the size of the training set to see the effect on the model fit and accuracy",0,1,value=0.7),
            submitButton("Submit"),
            h4("How to use this app:"),
            h5("This app uses data from the old faithful dataset, which records the eruption time in minutes and the waiting time to the next eruption for the Old Faithful geyser"),
            h5("The data is split into a 'training' set and a 'test' set according to the proportion set by the slider"),
            h5("The training set is used for fitting and calibrating a linear model to predict eruption time for a given waiting time. The training data and the model are shown on the left hand graph (waiting time on the x axis and eruption time on the y axis)"),
            h5("The test set is used to validate the accuracy of the model. The test data and the fitted linear model are shown on the right hand graph (waiting time on the x axis and eruption time on the y axis)"),
            h5("Underneath the graph is a description of the fitted linear model (the slope and intercept), and the residual mean squared error for the model as fitted to the training set and the test set (the larger the number, the less accurate the model)"),
            h5("Use the slider to see how different sizes of training and test sets affect the accuracy of the model on the test set"),
            h5("The graphs are interactive, so feel free to explore them")
        ),
        # Show a plot of the model fit on the training set and test set
        mainPanel(
            plotlyOutput("c_plot"),
            h3("Parameters of the fitted linear model, calibrated to the training set"),
            textOutput("params"),
            textOutput("desc"),
            h3("Root Mean Squared Error on the training set"),
            textOutput("train_RMSE"),
            h3("Root Mean Squared Error on the test set"),
            textOutput("test_RMSE")
        )
    )
))
