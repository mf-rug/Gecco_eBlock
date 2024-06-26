
library(shiny)
library(DT)
library(tidyverse)
library(BiocManager)
library(Biostrings)
library(stringr)
library(dplyr)
library(openxlsx)
library(shinyjs)
library(shinyWidgets)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  # App title
  titlePanel("eBlock Design"),
  
  # Horizontal line
  hr(),
  
  fluidRow(
    # Left column (occupies the left half)
    column(
      width = 6,
      HTML("<strong>Paste your FASTA or tab-separated sequences below:</strong>"), br(), br(),
      textAreaInput(
        inputId = "fasta_input",
        #         value='>prob
        # ATGTCGGGGAAGATTGATAAAATCTTAATTGTTGGCGGCGGAACGGCCGGTTGGATGGCTGCGTCCTATTTGGGGAAAGCGTTACAAGGAACCGCTGACATCACTTTATTGCAGGCACCTGATATTCCCACACTGGGCGTGGGAGAGGCAACGATCCCCAACCTTCAGACAGCCTTCTTCGACTTCCTTGGGATTCCTGAAGATGAGTGGATGCGCGAATGCAATGCAAGCTATAAAGTAGCTATCAAGTTTATTAACTGGCGTACAGCAGGTGAAGGAACTAGTGAAGCCCGCGAGTTGGACGGGGGACCAGACCATTTTTACCATTCGTTTGGTCTTCTTAAGTATCATGAGCAAATCCCTTTAAGTCATTACTGGTTTGATCGTTCATATCGTGGAAAGACAGTGGAGCCTTTTGACTATGCCTGCTACAAAGAGCCTGTAATCTTAGATGCTAATCGCTCGCCACGCCGTCTTGATGGGTCTAAAGTGACCAACTACGCGTGGCACTTTGACGCCCACTTGGTAGCTGACTTCTTGCGTCGTTTCGCCACGGAAAAATTGGGAGTTCGTCATGTTGAAGACCGCGTGGAACACGTTCAGCGCGACGCGAATGGTAACATCGAATCGGTACGCACAGCGACGGGCCGCGTATTCGACGCAGATTTATTTGTAGACTGTTCGGGGTTTCGTGGTCTGTTAATCAATAAGGCCATGGAGGAGCCATTTCTGGACATGAGTGATCACTTGCTGAACGACAGCGCAGTGGCTACTCAGGTACCCCATGATGATGACGCCAACGGTGTCGAGCCATTCACTTCCGCAATTGCTATGAAGTCAGGTTGGACATGGAAAATTCCCATGCTTGGTCGTTTTGGCACGGGCTACGTCTATTCTTCGCGCTTTGCCACTGAAGATGAGGCAGTTCGCGAATTCTGTGAGATGTGGCATCTTGATCCGGAAACCCAACCGTTAAACCGCATTCGTTTCCGTGTAGGACGTAACCGCCGTGCGTGGGTCGGAAACTGTGTTTCAATCGGTACGTCTTCTTGTTTCGTAGAGCCCCTTGAGTCGACGGGAATCTACTTTGTCTACGCCGCGCTGTACCAATTAGTTAAGCATTTCCCTGATAAATCCTTAAACCCGGTTCTTACGGCTCGTTTTAATCGCGAAATCGAGACGATGTTCGACGATACGCGCGACTTTATCCAGGCCCATTTCTATTTCTCACCACGCACGGATACTCCCTTTTGGCGCGCTAACAAAGAACTGCGCTTGGCAGATGGAATGCAGGAAAAGATCGATATGTATCGCGCCGGGATGGCAATTAACGCTCCGGCCAGTGACGACGCCCAACTGTACTACGGGAATTTCGAAGAGGAGTTTCGTAACTTTTGGAACAATTCTAATTATTATTGTGTTTTGGCAGGGCTTGGCCTGGTTCCGGACGCTCCTTCTCCGCGCCTTGCACACATGCCGCAAGCCACAGAGTCGGTTGATGAGGTATTCGGCGCAGTGAAGGACCGTCAGCGTAACTTGCTGGAAACTTTGCCCAGTTTACATGAATTCCTGCGTCAACAGCATGGGCGT
        # >test
        # atcgatcgatcg',
        #         value =
        #           ">prob
        #           ATGTCGGGGAAGATTGATAAAATCTTAATTGTTGGCGGCGGAACGGCCGGTTGGATGGCTGCGTCCTATTTGGGGAAAGCGTTACAAGGAACCGCTGACATCACTTTATTGCAGGCACCTGATATTCCCACACTGGGCGTGGGAGAGGCAACGATCCCCAACCTTCAGACAGCCTTCTTCGACTTCCTTGGGATTCCTGAAGATGAGTGGATGCGCGAATGCAATGCAAGCTATAAAGTAGCTATCAAGTTTATTAACTGGCGTACAGCAGGTGAAGGAACTAGTGAAGCCCGCGAGTTGGACGGGGGACCAGACCATTTTTACCATTCGTTTGGTCTTCTTAAGTATCATGAGCAAATCCCTTTAAGTCATTACTGGTTTGATCGTTCATATCGTGGAAAGACAGTGGAGCCTTTTGACTATGCCTGCTACAAAGAGCCTGTAATCTTAGATGCTAATCGCTCGCCACGCCGTCTTGATGGGTCTAAAGTGACCAACTACGCGTGGCACTTTGACGCCCACTTGGTAGCTGACTTCTTGCGTCGTTTCGCCACGGAAAAATTGGGAGTTCGTCATGTTGAAGACCGCGTGGAACACGTTCAGCGCGACGCGAATGGTAACATCGAATCGGTACGCACAGCGACGGGCCGCGTATTCGACGCAGATTTATTTGTAGACTGTTCGGGGTTTCGTGGTCTGTTAATCAATAAGGCCATGGAGGAGCCATTTCTGGACATGAGTGATCACTTGCTGAACGACAGCGCAGTGGCTACTCAGGTACCCCATGATGATGACGCCAACGGTGTCGAGCCATTCACTTCCGCAATTGCTATGAAGTCAGGTTGGACATGGAAAATTCCCATGCTTGGTCGTTTTGGCACGGGCTACGTCTATTCTTCGCGCTTTGCCACTGAAGATGAGGCAGTTCGCGAATTCTGTGAGATGTGGCATCTTGATCCGGAAACCCAACCGTTAAACCGCATTCGTTTCCGTGTAGGACGTAACCGCCGTGCGTGGGTCGGAAACTGTGTTTCAATCGGTACGTCTTCTTGTTTCGTAGAGCCCCTTGAGTCGACGGGAATCTACTTTGTCTACGCCGCGCTGTACCAATTAGTTAAGCATTTCCCTGATAAATCCTTAAACCCGGTTCTTACGGCTCGTTTTAATCGCGAAATCGAGACGATGTTCGACGATACGCGCGACTTTATCCAGGCCCATTTCTATTTCTCACCACGCACGGATACTCCCTTTTGGCGCGCTAACAAAGAACTGCGCTTGGCAGATGGAATGCAGGAAAAGATCGATATGTATCGCGCCGGGATGGCAATTAACGCTCCGGCCAGTGACGACGCCCAACTGTACTACGGGAATTTCGAAGAGGAGTTTCGTAACTTTTGGAACAATTCTAATTATTATTGTGTTTTGGCAGGGCTTGGCCTGGTTCCGGACGCTCCTTCTCCGCGCCTTGCACACATGCCGCAAGCCACAGAGTCGGTTGATGAGGTATTCGGCGCAGTGAAGGACCGTCAGCGTAACTTGCTGGAAACTTTGCCCAGTTTACATGAATTCCTGCGTCAACAGCATGGGCGT
        # >A8
        # TGCACACCTCGCGTGCCCGCCCGTACCAATTGGGCAGGTAACTTGACTTATTCTACAAATCAGCTTTACCGTCCAGGGACAGTTGAAGAAGTGCAAGAGGTAGTGCGCCGCGCAGCCCGTGTACGTCCCCTGGGGTCCCGCCATTGTTTCAACACGATTGCCGACTCACAGCACGCTCAGCTTTCCTTGGAGTTGCTGCCACACGAGATTACTTTCGATGAAGGGACGGTGAGTGTCCCAGGATCTATGCGCTATGGAGAGTTAATTCCCTTCCTGAATAAACAAGGGGTGGCGTTACACAACTTGGCGAGTTTACCACATATCAGTGTTGCCGGAGCGTGCGCAACCGCCACGCACGGCTCAGGCATTACCAACGGTAATCTGGCTACAGCCGTACAGGGGATGGAAATCGTAAACGCCGCCGGGGAGTTGGTTTCGCTGTCTCGTGAAGCAGACCACCAGCGCTTTGCGGGCGCGGTAGTCGGGCTTGGAAGCTTGGGAGTTGTCACGCGTGTTGCCCTGCGTACTGAACCCTCTTATAACGTGCGTCAGTATGTCTATTTGGACGTTCCGTTGGACAGCGTAGGTCAGTATTTTAATGAGATCCTGGCGCGTGCGTATTCAGTATCTATCTTTACGGATTGGCAGACGACGGAATCAACCCAAATCTGGATTAAGGAGCGCGCCGATCAGGTGTTAGAGCCTATCGAACAGGAACTGTTTGGGGGGCAACTTGCTGATCGTAAAGTTCATCCAGTACTGGCACTTAGCGCTGAGGCGTGCACGGAGCAAATGGGAGCAGTTGGGCCGTGGCACGCGTTACTGCCTCATTTCAAAATGGAGTTTACACCGTCCTCTGGTGAAGAATTACAGACCGAGTTTTTCGTAGCGCGTGAAAACGCGCCCGCAGTTGCTGAAGTCTTGCGTGGTATGTCGGACCAGTTAAACCCTCTTCTTATGATTTCGGAAGTTCGTAGCATTAAGGCAGATGATCTGTGGATGTCAACTGCATATGGCCGTGATTCTGTCGCATTCCATTTCACTTGGTATCAGGATTGGGAGGGGCTTCAAGCGTTGCTTCCGACCCTTGAGGAAGCACTTTCGCCCTTCGACATCCGTCCGCACTGGGGAAAGAATTTTGGAATGGAGCCTGCTGTGCTTCGCTCACGTTATGAAAAGTTAAATGATTTCCGTACTCTGGTGAACGAGTTTGACCCTTCAGGCAAATTTCGCAATGCATTTACGCAACGCTACTTGAGCGGA
        # >A9
        # ATGGCCGGACCATCCACTAATCGCCAAGCAGCGGGAGCAAACCGTGCCGAAACCGGGCCAGAGGCGAACCGTGCAGGGACCGGCCCTGACTCTAATCCGGCCGGGGCAGGCTCTGATAGTAACCGCACAGGGACAGCCCCAAATACCATCCCTGCCGGGGCGGGTCCAACGACTGATCCGACTGCTACCGGCCCCGATATTACGCCGGCGCGCACGGCTGCGCCTGATACGAACCAGACCGATCCTGGGCCAACCACGACACGCACCGGTACCCGCCCAAACACCAATCCGACAGCGACGGCGCCTGATACCACGCCCGCACCAACTGCTCCGGATACTAATCGTATTGACGCAGCTCCTGACACCAACCGTACAGACGCTGCACCGACTACGACTCCCCCACCGACTGCTCCAGTGACGAATTGGGCCGGTAACATCCGTTTCCGCGCTAGTCGTCGTGCAGCTCCCGGTTGTGTGGACGATGTACGCGAATTAGTCGCCGCTTCTCGCACCGTGCGCGTCTTGGGTACTGGGCACTCGTTCAATGATTTAGCGGACACTACGGGGCTGTTATTAGCCACTAGCGCTTTGCCTAAGAGTGTGGAGATTGATGCACGCGCCGGTACAGTTACGGTTGGCGCTGGAGTGCGCTTTGGGGAGCTGACCGGCGTCCTTCACGCTAGTGGTCACGCACTGCATAACCTGGGCTCCTTACCACACATTTCGGTTGCCGGAGCGTGCGCCACCGGGACGCACGGAGCTGGAGTGGGGAACCCTTCTTTGGCAGCTGCGGTACGCGCGCTGGAGTTGGTTACCGCCGATGGTGAGCTTCTTACATTGGACCGCAGTGACGAACGTTTCCCGGGTTCCGTTGTCGCTCTGGGGGCACTGGGTGTCGTTACACGCGTCACTTTGGGCCTGGTGCCAGCATTTGATGTCCGTCAATGGGTGTATGAGGGGTTGCCCACTGCTGCGTTGCGCGATGGTTTGGACGAAGTGTTATCTGCTGCATACTCCGTGTCTTTATTCACTCGTTGGCGCGGTGAACGTGTCGAGCAAGTCTGGCTTAAACAACGCGTAGATGGGGCTGCTCCGGTATGTCTGCCCGGCGCACGCTTAGCCGATGGTCCTCGTCATCCCGTCCCCGGTATGGCGCCCGAGGCATGTACACCTCAGGGTGGGGTGCCCGGTCCATGGCACACGCGTTTACCCCACTTTCGCTTAGAGCATATCCCTTCGTCAGGCGCGGAAACCCAATCAGAATATTTTGTGGCACGTTCTGACGCGTCGGCTGCATTTGCAGCCCTTGACCGCGTACGTGAAGAATTTGCCCCGGTGCTTCGCATCGGCGAAGTTCGTGCGGTTGCCGCAGATGATTTATGGCTTTCGCCTGCCCACCGTCGTGACTCAGTCGCGTTTCATTTCACCTGGCTTCCGGATGCACCAGCAGTGGCTCAAGCTCTGCATCATGTTGAACGTGCACTGGCACCGTTCGCGCCGCGCCCTCATTGGGGTAAAGTGTTCGTGACGCCGCCAGAAACACTTCGTGAACGTTATGAGCATCACGACCGTTTTCGCCGCTTGATGACGGCGTTAGACCCCGCCGGTAAGTTTCGTAATGACTTTCTTCGTCGTCACTTTCCG
        # >A10
        # ATGTCGCAGCGCAATTGGTCGGAAAATATCCGTTTCGCTTCAGCGGAGATTCACGCCCCGCGTACTGTCGAGGCGTTGCAAGAAATCGTCCGCGCAAGTCGTAAGGTCCGCGTACTGGGTGCCCGTCATTCTTTTAACGATGCGGCGGCGATCGACGCCCAAGTCGATGTTGATGGGACCCAAGAAGTCTCTGGTGATCCCTCGTGGGCCTACATTTCACTTGAGAACCTGGACGCCCCCGTCGAGTTCGACCACGAATCAGGCACAGTTACCTGTAGCGGGGGAATTACGTACGGTGAATTATGTACGCAAATGCACGCCGAAGGGGTCGCGTTGCATAACACTGCTTCGTTGCCGCATATCACAGTTGCCGGTGCTTGCTCAACGGCCACACACGGTTCCGGTGACGGAAACGGTAATCTTGCGACCGCCGTTGTTGGGATGGAACTTGTGACTGCAGATGGAGACTTGAAACTGATGACACTTGAGAAGGACCGCGAAGATTTCGAGGGCTCTGTTGTGGCGTTGGGGGGGCTTGGCGTGGTGACACGTATGACCCTGGCGATGGAGCCGGCATATTCTATGCAACAGTACGTTTATAACGACTTACCATCTGCCACCTTATATGATAATTTCGATGAAATCATGTCCCGCGCGTACTCAGTGTCTCTGTTCCCTGATTGGCAGGGTGACACCGTCAATCAAGTTTGGTTTAAGCATCGTACAGGGCGCTGGGGTGTCAACGGCCAGCAAGCAACGGAGCCAGAAGCTGTGGACTTAGGGTTGCCGTCCGAATTGTATTCAGCCAAAGCGGCAAGTACACACTTGCATCCAGTTCCTGAGTTAAGTGCTGAAGGCTTGACACTGCAAATGGGAATTCCAGGTGCCTGGCACGACCGCTTACATCACTTCCAGATTGATAGTACCCCGGCTTCGGGGGACGAATTACAAACGGAGTATTTCGTTCCGCGCGCTCATGCGGTACCAGCCCTTCAGGCAGTGGAGGTCTTACGTGACCGCTTCCGCTCTATGCTGTGGATCTCTGAAATCCGCTCGGTTGCAGCGGATCGTTTATGGCTTAGCCAGTCCTACGGCACGCCAACTATCGGGATTCATTTCAGTTGGCGTAAGAACTGGCCAGCAGTTCGTGAGGTAATGCCCCTGGTGGAGGAGGCTCTTGCACCCTTCGAAGTACGTCCACACTGGGGGAAACTTTTTTCAATCGCGCCTAAGCAAGTACAGGCCGCATTTCCTCGCATGGAAGACTTCAAGGCGCTGCTGGGCAGTGCAGATCCAGAAGGGAAGTTTCGTAATGGGTATCTGGATCGTTACGTTTTCGGG",
        #         # ">Seq1
        #         # GAAGTCCAGCTGCAGCAGTCTGGACCTGAGCTGGTGAAGCCTGGGGCTTCAGTGAAGATATCCTGCAAGGCTTCTGGTTATTCTTTCACTGGCTTCTACATAGACTGGGTGAAGCAGAGTCCTGGAAAGAGCCTTGAGTGGATTGGATATATTTTTCCTTCCAATGGTGAAACCAGCTACAACCAGAAGTTCAAGGGCAAGGCCACATTGACTGTAGACAAATCTTCCAGCACAGTCAACATGCAGCTCAACAGCCTGACATCTGAGGACTCTGCAGTCTATTACTGTGCAAGACAGGCTTTTTACTACTTTGACTACTGGGGCCAAGGCACCACTCTCACAGTCTCCTCA",
        label = NULL,
        placeholder = "Paste FASTA sequences here...",
        width = '100%',
        height = '27vh'
      )
    ),
    # Right column (occupies the right half)
    column(
      width = 6,
      HTML("<strong>Extracted Sequences</strong>"), br(),br(),
      DTOutput("fasta_table", width = '45vw'),
    )
  ),
  tags$hr(style = "border-color: black;"),
  
  shinyjs::hidden(
    div(id = 'hidden_div',
      div(style = "background-color: #F4FAFA ; padding: 5px;",
        div(HTML("<strong><p style = 'color: #033939;'>Suggested sequence without BsaI sites</p></strong>"), style = "float: left;"),
        div(downloadButton("downloadCSV_wo_bsai", "Download BsaI-free seqs as .xlsx File"), style = "float: right;"),
        br(),
        hr(),
        textAreaInput("mod_seq", NULL, width = "100%", height='15vh'),
        hr()
      ),
      
      tags$hr(style = "border-color: black;"),
      div(style = "background-color: #F4F6F9 ; padding: 5px;",
        div(HTML("<strong><p style = 'color: #030a39;'>Fragments</p></strong>"), style = "float: left;"),
        div(downloadButton("downloadXLS_fragm", "Download Fragments as .xlsx"), style = "float: right;"),
        br(),
        hr(),
        ## Create a text input for the DNA sequence to be introduced by the user
        fluidRow(
          column(3, HTML('Choose parameters:')),
          column(4, textInput('frag_len', 'eblock fragment max. length', value = 1400)),
          column(4,
            materialSwitch(
              "full_seq",
              "show whole sequence",
              value = FALSE,
              right = TRUE,
              status = 'primary'
            ),
            materialSwitch(
              "hl_bsai",
              "Highlight BsaI sites",
              value = TRUE,
              right = TRUE,
              status = 'primary'
            ),
          )
        ),
        DTOutput("frag_table", width = "95vw")
      ),
      tags$hr(style = "border-color: black;"),
      div(style = "background-color: #F9F7FA; padding: 5px;",
    
        div(style = "width: 100%;",
            div(HTML('<strong><p style = "color: #290339;">Plasmid</p></strong>'), style = "float: left;"),
            div(selectInput("plasmid", NULL, c("pBAD", "pBAD SUMO")), style = "float: left; margin-left: 20px;"),
            div(downloadButton("downloadCSV_vector", "Download Excel File"), style = "float: right;")
          ), 
        br(),
        tags$hr(style = "margin-top: 25px; margin-bottom: 10px;"),
        DTOutput("whole_seq_table", width = "95vw")
      )
    )
  ),
  shinyjs::hidden(
      div(id = 'invalid', HTML('<p style="color: red;">An error occurred while processing the input. Please provide (a) valid fasta or tab-separated formated sequence(s) as input.</p>'))
  )
)
