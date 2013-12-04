.doSaveDependencies <- function(funcOrFuncName,envir=NULL, newenvir=new.env(),.buffer={},.do.verbose=PADebug()) {
  if (typeof(funcOrFuncName) == "character") {
    # if in buffer, then already inspected
    if (is.element(funcOrFuncName, .buffer)) {
      return(list(NULL,.buffer))
    }
    
    if (.do.verbose) {
      print(str_c(" // processing function: '", funcOrFuncName,"'"))
    }
    if (is.null(envir)) {
      func <- tryCatch( get(funcOrFuncName), error = function(e) {message(e);return(NULL)} );
    } else {
      func <- tryCatch( get(funcOrFuncName,envir), error = function(e) {message(e);return(NULL)} );
    }
    if (is.null(func)) {
      return(list(NULL,.buffer))
    }
    .buffer <- append(.buffer,funcOrFuncName)
    out <- {funcOrFuncName};
    # assign the variable in my private environment
    assign(funcOrFuncName, func, envir=newenvir);
    
  } else {
    func <- funcOrFuncName;
    out <- {};
  }
  
  if (is.null(envir)) {
    envir <- environment(func)
  }
  globs <- findGlobals(func)
  
  
  for (varName in globs) {
    var <- tryCatch( get(varName,envir), error = function(e) {message(e);return(NULL)} );
    if (!is.null(var)) {
      envirvar <- environment(var)
      pck <- environmentName(envirvar);
      if ((pck != ".Primitive") && (pck != "base")) {
        tovar <- typeof(var);
        # assign the variable in my private environment
        assign(varName, var, envir=newenvir);
        if (tovar == "closure") {
          outsubpair <- .doSaveDependencies(varName,envir=envirvar,newenvir=newenvir, .buffer=.buffer ,.do.verbose=.do.verbose)
          out <- union(out, outsubpair[[1]]);
          .buffer <- union(.buffer, outsubpair[[2]]);
          
        } else if (tovar == "list") {
          out <- union(out, varName); # adding the function variable in the list to the output
          outsubpair <- .doSaveListDependencies(varName,envir=envirvar,newenvir=newenvir, .buffer=.buffer ,.do.verbose=.do.verbose) # adding the dependencies of this variable
          out <- union(out, outsubpair[[1]]);
          .buffer <- union(.buffer, outsubpair[[2]]);  # merging the already parsed functions
          
        } else if (is.element(tovar,c("symbol","logical","integer", "double", "complex", "character","list","raw"))) {
          out <- union(out, varName)
        }
      }
    }
  }
  return(list(out,.buffer))
};

.doSaveListDependencies <- function(lstvarName,envir=NULL, newenvir=new.env(),.buffer={},.do.verbose=PADebug()) {
  lstvar <- tryCatch( get(lstvarName,envir), error = function(e) {message(e);return(NULL)} );
  assign(lstvarName, lstvar, envir=newenvir);
  for(el in lstvar) {
    toelem = typeof(el);
    if (toelem == "list") {
      outsubpair <- .doSaveListDependencies(el,envir, .buffer ,.do.verbose)
      out <- union(out, outsubpair[[1]]);
      .buffer <- union(.buffer, outsubpair[[2]]);
    } else if (tovar == "closure") {
      outsubpair <- .doSaveDependencies(el,envir=envir, .buffer=.buffer ,.do.verbose=.do.verbose)
      out <- union(out, outsubpair[[1]]);
      .buffer <- union(.buffer, outsubpair[[2]]);
    }
  }
  return(list(out,.buffer))
};

.PASolve_saveDependencies <- function(subpair,newenvir,file) {
  
  # print(str_c("saving ",file))
  save(list = subpair,file = file, envir = newenvir);
  # print(str_c(file," saved"))
};

.PASolve_computeDependencies <- function(funname,envir=environment(),.do.verbose=PADebug()) {
  newenvir <- new.env()
  func <- get(funname,envir)
  assign(funname, func, envir = newenvir)
  outsubpair <- .doSaveDependencies(funname,newenvir=newenvir,.do.verbose=.do.verbose)
  return(list(subpair = outsubpair[[1]],newenvir = newenvir))
}