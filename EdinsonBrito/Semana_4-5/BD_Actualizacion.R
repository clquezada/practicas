Actualizacion_ncbi <- function(table, config){
  
  
  source(config)
  if(is.data.frame(table)){} else {table <- read.csv(table, sep= Taxon_sep, stringsAsFactors=F)}
  
  table[2][is.na(table[2])] <- "" # replace NAs if only orders are given
  
  folder <- which(table[,1]!="")
  folder <- c(folder, nrow(table)+1)
  
  table[folder,]
  
  for (i in 1:(length(folder)-1)){
    subFolder <- table[folder[i],1]
    subStart <- folder[i]+1
    subEnd <- folder[i+1]-1
    
    dir.create(subFolder, showWarnings=F)
    #setwd(subFolder) # set up folder and paste files!
    
    subFolderPath <- paste(subFolder, "/", sep="") # set op filepath
    
    
    
    # define range!
    if (table[subEnd,2]==""){taxa <- subFolder} else {
      taxa <- table[subStart:subEnd, 2]}
    
    
    # check if downloading and clustering is already done!
    download_and_cluster <- T # tipicly data has not been processed
    
    if(Skip_if_complete){
      done <- file.exists(paste(subFolder, "/", "Actualizaconlog.txt", sep=""))
      
      if(done){
        download_and_cluster <- F # DON'T REDOWNLOAD DATA
        time <- readLines(paste(subFolder, "/", "done.txt", sep=""), warn=F)
        message(paste("Data for *", subFolder, "* was already downloaded and clustered on ", time[1], " and will thus be skipped. Turn Skip_if_complete to F, if you like data to be redownloaded and reclustered or delete the file done.txt in the folder ", subFolder,  sep=""))
        message(" ")
        message("-------------------")
        message(" ")
      }
    }
    
    if(download_and_cluster){
      
      # download data!
      
      if (Download){
  
        if (download_GB){Descarga_Act(taxa, folder= subFolderPath, marker=Marker, maxlength= maxlength_GB, custom_query= custom_query_GB, setwd=subFolder, GB_subset=GB_Subset)}
        
      }
      message(" ")
      # merge files!

    }
    
  } 
  
 
  message(" ")
  message("Actualizacion descargada")
  return(subFolder)

} 

Descarga_Act <- function(taxon, folder=NULL, marker=c("COi", "CO1", "COXi", "COX1"), maxlength=2000, custom_query=NULL, setwd=NULL, GB_subset=NULL){
  
  if(!is.null(setwd)){logfile <- paste(setwd, "/log.txt", sep="")} else {logfile <- "log.txt"}
  
  
  cat(paste(Sys.time(), "- Downloading GenBank sequence data\n\n"), file=logfile, sep="", append=T)
  
  if (is.null(custom_query)){cat(paste("Search query: REPLACE_WITH_TAXA", "[Organism] AND (", paste(c(marker), collapse=" OR "), ") AND 1:",maxlength ,"[Sequence Length]\n\n", sep=""), file=logfile, sep="", append=T)} else {cat(paste("Search query: REPLACE_WITH_TAXA", custom_query, "\n\n", sep=""), file=logfile, sep="", append=T)}
  
  folder_path <- ""
  if(!is.null(folder)){dir.create(folder, showWarnings=F)
    folder_path <- paste(folder, "/", sep="")
    cat(paste("#GB_data: Folder ",folder, "\n", sep=""), file=logfile, sep="", append=T)
  } else {cat(paste("#GB_data: ", "\n", sep=""), file=logfile, sep="", append=T)}
  cat("Taxon\tSequences\tdownl_time\n", file=logfile, sep="", append=T)
  
  for (k in 1:length(taxon)){
    time <- Sys.time() # get time
    
    
    # download IDs
    if (is.null(custom_query)){
      searchQ <- paste(taxon[k],"[Organism] AND (", paste(c(marker), collapse=" OR "), ") AND 1:",maxlength ,"[Sequence Length]", sep="")
    } else {searchQ <- paste(taxon, custom_query, sep="")}
    
    
    
    if(is.null(GB_subset)){
      search_results <- entrez_search(db="nuccore", term=searchQ, retmax=9999999, use_history=T)} else {search_results <- entrez_search(db="nuccore", term=searchQ, retmax=9999999, use_history=F)}
    
    message(length(search_results$ids)," seqences detected for ", taxon[k])
    numberofsequences <- length(search_results$ids)
    
    # Add rarefaction
    
    if(!is.null(GB_subset)){
      if(GB_subset<length(search_results$ids)){
        search_results <- search_results$ids
        search_results <- sample(search_results, GB_subset)
      } else {search_results <- entrez_search(db="nuccore", term=searchQ, retmax=9999999, use_history=T)}
    }
    # add rarfaction end
    
    
    if(numberofsequences!=0){
      
      cat("", file=paste(folder_path, taxon[k], "_GB_Act.fasta", sep=""), sep="", append=F) # overwrite old file!
      
      # IF RERECATION SHOULD BE APPLIED
      if(!is.list(search_results)){
        
        message("Using GB_subset = ", GB_subset)
        start <-0
        i <- 1
        chunks <- length(search_results)/300
        if (!is.integer(chunks)){chunks <- as.integer(length(search_results)/300)+1}
        for(i in 1:chunks){
          
          tempID <- search_results[(i*300-299):(i*300)]
          tempID <- tempID[!is.na(tempID)]
          #print(tempID)
          message(if((start+300)<length(search_results)){start + 300}else{length(search_results)}, "/", length(search_results))
          
          downloaded_sequ <- entrez_fetch(db="nuccore", id= tempID, rettype="fasta", retmax=300)
          
          
          cat(downloaded_sequ, file=paste(folder_path, taxon[k], "_GB_Act.fasta", sep=""), sep="", append=T)
          
          start <- start + 300
          Sys.sleep(1)
          
        }
        
      } else {
        # ELSE (USE HISTORY)
        message("Not using subsetting! (set GB_subset=2000 if downloading takes too long or crashes)")
        i <- 1
        start <- 0
        
        chunks <- length(search_results$ids)/10000
        if (!is.integer(chunks)){chunks <- as.integer(length(search_results$ids)/10000)+1}
        for(i in 1:chunks){
          
          downloaded_sequ <- entrez_fetch(db="nuccore", web_history= search_results$web_history, rettype="fasta", retmax=10000, retstart= start)
          
          cat(downloaded_sequ, file=paste(folder_path, taxon[k], "_GB_Act.fasta", sep=""), sep="", append=T)
          
          start <- start + 10000
          Sys.sleep(1.5)
          
        }
        
        
      }
      # END DL
      
      
      meep <- read.fasta(paste(folder_path, taxon[k], "_GB_Act.fasta", sep=""))
      if (length(meep)!=if(!is.list(search_results)){length(search_results)}else{length(search_results$ids)}){
        warning("WARNING: Something went wrong with the download. Numer of files in GB does not match number of downloaded files!")
        cat(paste("\nWARNING: Something went wrong with the download. Numer of files in GB does not match number of downloaded files!\n\n"), file=logfile, sep="", append=T)}
      
      time <- Sys.time() - time
      message(paste("Downloaded ", if(!is.list(search_results)){length(search_results)}else{length(search_results$ids)}," sequences for ", taxon[k], " in ", format(time, digits=2), " from NCBI.", sep=""))
      cat(paste(taxon[k],"\t", if(!is.list(search_results)){length(search_results)}else{length(search_results$ids)}, "\t", format(time, digits=2), "\n", sep=""), file=logfile, sep="", append=T)
      
    }
    
  }
  
  cat("#GB_data_end\n\n", file=logfile, sep="", append=T)

}

Actualizacion_ncbi