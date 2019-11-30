library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    library(caret)
    data(faithful)

    # create the training set and populate with values predicted from a linear model
    trainFaith <- reactive({
        set.seed(333)
        train_prop <- input$train_prop
        inTrain <- createDataPartition(y=faithful$waiting,p=train_prop,list=FALSE)
        trainFaith <- faithful[inTrain,]
        lm1 <- lm(eruptions ~ waiting,data=trainFaith)
        trainFaith$preds <- predict(lm1)
        trainFaith
    })    
    # create the test set and populate with values predicted from a linear model
    testFaith <- reactive({
        set.seed(333)
        train_prop <- input$train_prop
        inTrain <- createDataPartition(y=faithful$waiting,p=train_prop,list=FALSE)
        trainFaith <- faithful[inTrain,]
        testFaith <- faithful[-inTrain,]
        lm2 <- lm(eruptions ~ waiting,data=trainFaith)
        testFaith$preds <- predict(lm2,newdata = testFaith)
        testFaith
    })    
    modvals <- reactive({
        set.seed(333)
        train_prop <- input$train_prop
        inTrain <- createDataPartition(y=faithful$waiting,p=train_prop,list=FALSE)
        trainFaith <- faithful[inTrain,]
        lm1 <- lm(eruptions ~ waiting,data=trainFaith)
        lm1$coefficients
    })
    output$params <- renderText({
        paste0("Intercept: ", format(round(modvals()[1],2),nsmall=2), " Slope: ",format(round(modvals()[2],4),nsmall=4))
    })
    output$desc <- renderText({
        paste0("Eruption time = ","waiting time * ",format(round(modvals()[2],4),nsmall=4)," ",format(round(modvals()[1],2),nsmall=2))
    })
    # plot the training data and the fitted model
    library(plotly)
    x <- list(title="Waiting time")
    y <- list(title="Duration of eruption")
    output$c_plot <- renderPlotly({
        p1 <- plot_ly(trainFaith(),x=~waiting) %>%
                add_trace(y=~eruptions, type = 'scatter',mode='markers',name="Training data") %>%
                add_trace(y=~preds,type = 'scatter',mode='lines',name="Fitted model",color='orange') %>%
                layout(xaxis = x,yaxis=y)     
        p2 <- plot_ly(testFaith(),x=~waiting) %>%
                add_trace(y=~eruptions, type = 'scatter',mode='markers',name="Test data") %>%
                add_trace(y=~preds,type = 'scatter',mode='lines',name="Fitted model",color='orange') %>%
                layout(xaxis = x,yaxis=y)
        subplot(p1,p2)
    })
#    # calculate the RMSE on the training and test sets
    output$train_RMSE <- renderText({
        sqrt(mean((trainFaith()$preds-trainFaith()$eruptions)^2))
    })
    output$test_RMSE <- renderText({
        sqrt(mean((testFaith()$preds-testFaith()$eruptions)^2))
    })
})
