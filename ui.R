dashboardPage(
  
  dashboardHeader(title = "Pedidos de reembolso dos deputados federais brasileiros"
  ),
  
  dashboardSidebar( sidebarMenu(
    # menuItem("Barplot", tabName = "bar", icon = icon("bar-chart", lib = "font-awesome")),
    # menuItem("Tabela", tabName = "tabela", icon = icon("table",lib = "font-awesome")),
    menuItem("Reembolsos", tabName = "dash", icon = icon("search dollar",lib = "font-awesome")),
    
    menuItem("Sobre", tabName = "sobre", icon = icon("question-circle",lib = "font-awesome"))
  )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dash",
              fluidRow(
                box(width = 12,height = 100,status = "warning", title = "DIGITE O NOME DO SEU DEPUTADO FEDERAL:",
                    background = "light-blue",
                    selectInput("parl",label = NULL, choices =unique(as.character(camara$congressperson_name)),selected="ABELARDO")),
                
                # box(width = 6,height = 100,status = "warning", title = "Total reembolsado:",
                #     background = "light-blue",
                #     verbatimTextOutput("total")),
                valueBoxOutput(width = 6,"partido"),
                valueBoxOutput(width = 6,"estado"),
                valueBoxOutput(width = 6,"totalbox"),
                valueBoxOutput(width = 6,"diffbox"),
                valueBoxOutput(width = 6,"distbox"),
                valueBoxOutput(width = 6,"percentildiffbox"),
                
                box(status = "warning",title="Empresas que o deputado mais pede reembolsos",width = 12,
                    plotOutput('gasto_tree')),
                
                box(status = "warning",title="Valor total reembolsado e pedido por ano em R$",width = 12,
                    plotOutput('diferenca_graf')),
                
                box(status = "warning",title="Top 10 tipos de gastos:",width = 12,
                    plotOutput('top_10gastos')),
                
                box(status = "warning",title="Top 10 empresas em que o deputado mais pede reembolso:",width = 12,
                    plotOutput('top_10empresas')),
                
                box( width = 12, status = "warning",
                     dataTableOutput('tabela')),
                
                # box(status = "warning",
                #   downloadLink("ReembolsosDeputado", 'Download da tabela acima'))
                box(downloadButton("downloadData",label="download" ))
              )
              
              
              
              
              
      ),
      tabItem(tabName = "sobre",
              fluidRow(
                tabBox(
                  title = "Sobre:",
                  side = "right", height = "250px",
                  selected = "Desenvolvedores",
                  tabPanel("Motivação", "Alem do salário, os deputados federais tem o direito de pedir o reembolso de gastos com alimentação, combustível, locação de veículos, passagens aéreas, material de escritório e divulgação da atividade parlamentar.
                           Com esta plataforma, esperamos oferecer uma maneira fácil e prática de acompanhar como um determinado deputado está gastando estes recursos"),
                  
                  tabPanel("Desenvolvedores", h2("Marcus Alexandre Nunes"), align = "left", " Doutor em Estatística pela Penn State University", br(),
                           "Mestre em Matemática Pura pela Universidade Federal do Rio Grande do Sul", br(),
                           "Bacharel em Matemática Aplicada e Computacional pela Universidade Federal do Rio Grande do Sul",br(),
                           a("https://marcusnunes.me", href="https://marcusnunes.me", target="_blank"),br(),
                           a("https://github.com/mnunes", href="https://github.com/mnunes", target="_blank"),
                           br(),
                           h2("Rayland Matos Magalhães"),"Graduando em Estatística pela Universidade Federal do Rio Grande do Norte",br(),a("https://github.com/raylandmagalhaes", href="https://github.com/raylandmagalhaes", target="_blank"),
                           br(),
                           h2("Serenata de Amor"),"Este trabalho não teria sido possível sem as ferramentas de coleta de dados públicos desenvolvidas pelo Projeto Serenata de Amor",br(),a("https://serenata.ai/", href="https://serenata.ai/", target="_blank")),
                  
                  tabPanel("Projeto","Esta plataforma é um projeto de iniciação científica que tem como orientador o professor", strong("MARCUS ALEXANDRE NUNES"), "e como discente voluntário, o aluno de graduação", strong("RAYLAND MATOS MAGALHÃES")," (vide aba 'Desenvolvedores') ",br(),br(),
                           p("A Lei de Acesso à informação, promulgada em 16 de maio de 2012, trouxe uma quantidade de informação sem precedentes para a sociedade brasileira. Através dela, os órgãos públicos integrantes da administração direta dos Poderes Executivo, Legislativo, incluindo as Cortes de Contas, e Judiciário e do Ministério Público devem informar seus gastos com material, salários, licitações e tudo o mais que envolver dinheiro público."),
                           
                           p("A Câmara dos Deputados mantém registrados todos os pedidos de reembolsos feitos pelos deputados federais desde 2009. Até o final de 2017 eram 3.099.310 de pedidos de reembolso catalogados. Embora os dados estejam disponíveis para quem quiser acessá-los, eles nem sempre estão acessíveis, pois a maneira com a qual estão organizados demanda um grande conhecimento técnico para que sejam extraídos e analisados. Assim, a maior parte da população não consegue ter acesso a eles."),
                           
                           p("Um primeiro passo no sentido de tornar estes dados acessíveis foi dado pela Operação Serenata de Amor, parte da iniciativa Open Knowledge Brasil. Esta Operação recolheu os dados referentes aos pedidos de reembolsos dos deputados federais e tornou-os acessíveis através de um módulo escrito em python (Python Software Foundation, 2017). Nunes (2018) utilizou este módulo para criar um pacote em R (R Core Team, 2018) com os dados coletados e compactados, a fim de deixar estas informações mais difundidas na sociedade."),
                           
                           p("Entretanto, mesmo com os dados disponíveis para duas linguagens de programação, pessoas que não tem conhecimento em python ou R continuam sem ter acesso a estes dados. Desta forma, a maior parte da população brasileira não tem acesso ao controle dos gastos dos deputados eleitos."),
                           
                           p("Este projeto vem preencher exatamente esta lacuna. Desejamos criar uma interface point and click que permita ao usuário filtrar, classificar e baixar os dados que ele deseja analisar ou conferir. O usuário poderá filtrar os gastos por tipo (refeição, passagem aérea, publicidade etc.), por partido, por estado do parlamentar e muitas outras variáveis. Depois da filtragem realizada, estes dados podem ser baixados e utilizados em outras pesquisas das mais diversas áreas. Ou apenas para controle da população sobre os gastos dos seus representantes no legislativo.")
                           
                  ))
              )
      )
    )
  )
)
#https://rstudio.github.io/shinydashboard/structure.html#mixed-row-and-column-layout