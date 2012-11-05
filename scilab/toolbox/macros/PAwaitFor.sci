function val_k=PAwaitFor(l,timeout)
    global('PA_solver')
    val_k = [];
    if typeof(l) == 'PAResL' then
        m = size(l.matrix,2);
        R=l.matrix(1).entries;
        jobid = R.jobid;
        jimport java.util.ArrayList;
        
        taskids = jnewInstance(ArrayList);
        allRes = %t;
        for i=1:m
            R = l.matrix(i).entries;
            rs = jinvoke(R.resultSet,'get');
            rw = jinvoke(R.waited,'get');            
            allRes = allRes & (rs | rw);
            jinvoke(taskids,'add',R.taskid); 
        end
        if ~allRes
            jimport java.lang.Integer;
            if argn(2) == 2                
                tout = jinvoke(Integer,'parseInt',string(timeout));
            else
                tout = jinvoke(Integer,'parseInt',string(-1));
            end
            try
                unrei = jinvoke(PA_solver,'waitAll',jobid,taskids, tout);
            catch
                // if an exception occur, it means the RMI stub is lost
                PAensureConnected();
                unrei = jinvoke(PA_solver,'waitAll',jobid,taskids, tout);
            end

            answers = jinvoke(unrei,'get');
        end

        val_k=list();
        anyerror = %f;
        for i=1:m
            R=l.matrix(i).entries;
            if ~allRes
                RaL = jinvoke(answers,'get',i-1);
                [tmpval,err] = PAResult_PAwaitFor(R,RaL);
                jremove(RaL);
                val_k($+1)=tmpval;
                if ~isempty(err) then
                    warning(err);
                    anyerror = %t;
                end
            else
                [tmpval,err] = PAResult_PAwaitFor(R);
                val_k($+1)=tmpval;
                if ~isempty(err) then
                    warning(err);
                    anyerror = %t;
                end
                
            end
        end
        if anyerror then
             warning('PAWaitFor:Error occured');
        end
        if ~allRes
            jremove(answers);
            jremove(unrei);
        end
        jremove(taskids);

    else        
        error('Expected argument of type PAResL, received '+typeof(l))
    end
endfunction
