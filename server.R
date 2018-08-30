function(input, output, session) {
  
  top_10gastos<-reactive({ camara%>%
      select(congressperson_name,total_net_value,subquota_description)%>%
      filter(congressperson_name==input$parl)%>%
      group_by(subquota_description)%>%
      summarise(soma=sum(total_net_value))%>%
      top_n(10)
    
  })
  output$top_10gastos <- renderPlot({
    legend_ord <- levels(with(top_10gastos(), reorder(subquota_description, -soma)))
    options(scipen=10000)
    ggplot(top_10gastos(),aes())+
      geom_col(aes(reorder(subquota_description,-soma),soma,fill = subquota_description))+
      theme_minimal()+
      labs(fill="Tipo de gasto",y="Valor total(R$)")+
      theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
      scale_fill_discrete(breaks=legend_ord)
  })
  
  top_10empresas<-reactive({ camara%>%
      select(congressperson_name,total_net_value,supplier)%>%
      filter(congressperson_name==input$parl)%>%
      group_by(supplier)%>%
      summarise(soma=sum(total_net_value))%>%
      top_n(10)
  })
  
  output$top_10empresas <- renderPlot({
    legend_ord <- levels(with(top_10empresas(), reorder(supplier, -soma)))
    options(scipen=10000)
    ggplot(top_10empresas(),aes())+
      geom_col(aes(reorder(supplier,-soma),soma,fill = supplier))+
      theme_minimal()+
      labs(fill="Fornecedor",y="Valor total(R$)")+
      theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
      scale_fill_discrete(breaks=legend_ord)
  })
  
  gasto_tree<-reactive({ camara%>%
      select(congressperson_name,supplier,total_net_value)%>%
      filter(congressperson_name==input$parl)%>%
      group_by(supplier)%>%
      summarise(soma=sum(total_net_value))%>%
      top_n(30)
  })
  
  output$gasto_tree <- renderPlot({
    treemap(gasto_tree(),
            index="supplier",
            vSize="soma",
            type="index",
            title = ""
            
    )
  })
  
  output$tabela <- renderDataTable(
    
    dados<-camara%>%
      filter(congressperson_name==input$parl)%>%
      select(congressperson_name,document_value,issue_date,party  ,state,subquota_description,supplier,total_net_value,year)
    
  )
  
  
  output$total <- renderPrint({
    total=camara%>%
      select(congressperson_name,total_net_value)%>%
      filter(congressperson_name==input$parl)%>%
      summarise(soma=sum(total_net_value))
    total=as.data.frame(total)
    cat(paste0("R$",as.character(round(total,2))))
    
  })
  
  diferenca<-reactive({ camara%>%
      select(congressperson_name,document_value,total_net_value,year)%>%
      filter(congressperson_name==input$parl)%>%
      group_by(year)%>%
      summarise(pago=sum(total_net_value),pedido=sum(document_value))%>%
      gather(value="valor",key="situacao",pedido,pago)
  })
  
  output$diferenca_graf <- renderPlot({
    ggplot(diferenca(),aes(x=year,y=valor,colour=situacao))+
      geom_line()+
      geom_point()+
      theme_minimal()+
      scale_x_continuous(breaks = seq(min(camara$year), max(camara$year), by = 1))+
      labs(fill="situação" ,y="Valor total(R$)")+
      theme(axis.text.x = element_text(angle = 0, hjust = 1, vjust = 0.5))
  })
  
  
  output$totalbox <- renderValueBox({
    
    total=camara%>%
      select(congressperson_name,total_net_value)%>%
      filter(congressperson_name==input$parl)%>%
      summarise(soma=sum(total_net_value))
    total=as.data.frame(total)
    
    valueBox(
      value=paste0("R$",format(round(as.numeric(total),2), nsmall=2, big.mark=",")),
      "Reembolsados",
      icon = icon("money",lib = "font-awesome"),
      color = "light-blue"
    )
    
  })
  
  output$diffbox <- renderValueBox({
    
    total=camara%>%
      select(congressperson_name,total_net_value,document_value)%>%
      filter(congressperson_name==input$parl)%>%
      summarise(diferenca=abs(sum(total_net_value)-sum(document_value)))
    total=as.data.frame(total)
    
    valueBox(
      value=paste0("R$",format(round(as.numeric(total),2), nsmall=2, big.mark=",")),
      "De diferenca entre pedido e reembolsado",
      icon = icon("balance-scale",lib = "font-awesome"),
      color = "light-blue"
    )
    
  })
  
  output$percentildiffbox <- renderValueBox({ 
    b=camara%>%
      select(congressperson_name,total_net_value,document_value)%>%
      group_by(congressperson_name)%>%
      summarise(soma=abs(sum(total_net_value)-sum(document_value)))%>%
      arrange(soma)
    
    percentile_dif <- ecdf(b$soma)
    
    q=camara%>%
      filter(congressperson_name==input$parl)%>%
      select(congressperson_name,total_net_value,document_value)%>%
      summarise(soma=abs(sum(total_net_value)-sum(document_value)))
    valueBox(subtitle=paste0("dos deputados tem uma discrepancia entre o valor solicitado e valor recebido MENOR que ", input$parl ),
             value=paste0(round((percentile_dif(q$soma))*100,2),"%"),
             icon = icon("balance-scale",lib = "font-awesome"),
             color = "light-blue"
    )
  })
  
  
  output$distbox <- renderValueBox({ 
    a=camara%>%
      select(congressperson_name,total_net_value)%>%
      group_by(congressperson_name)%>%
      summarise(soma=sum(total_net_value))%>%
      arrange(soma)
    percentile_gasto <- ecdf(a$soma)
    
    q=camara%>%
      filter(congressperson_name==input$parl)%>%
      select(congressperson_name,total_net_value)%>%
      summarise(soma=sum(total_net_value))
    
    valueBox(subtitle=paste0("dos deputados pediram MENOS reembolsos que ", input$parl ),
             value=paste0(round((percentile_gasto(q$soma))*100,2),"%"),
             icon = icon("money",lib = "font-awesome"),
             color = "light-blue"
    )
  })
  
  output$partido <- renderValueBox({ 
    
    
    
    valueBox(subtitle=paste0("DEPUTADO(A) ", input$parl ),
             value=as.character(camara$party[camara$congressperson_name==input$parl][[1]]),
             icon = icon("user",lib = "font-awesome"),
             color = "light-blue"
    )
  })
  
  output$estado <- renderValueBox({ 
    
    
    
    valueBox(subtitle="         ¨",
             value=paste0("ELEITO EM ",as.character(camara$state[camara$congressperson_name==input$parl][[1]]) ),
             icon = icon("flag",lib = "font-awesome"),
             color = "light-blue"
    )
  })
}
