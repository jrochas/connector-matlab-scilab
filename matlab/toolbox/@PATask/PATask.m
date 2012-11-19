% PATask constructor of PATask objects
%
% Syntax
%       t = PATask(lin, col);
%
% Inputs
%       
%       lin - the number of lines of the PATask matrix to create
%       col - the number of columns of the PATask matrix to create
%
% Outputs
%       
%       t - a PATask matrix
%
% Properties 
%
%       Func - a matlab function handle (the function to execute remotely)
%       
%       Params - a cell array containing the list of parameters for the
%       "Func" function
%       
%       Description - a textual description of this task (string)
%
%       InputFiles - a PAFile array containing information about
%       the desired input files used by this task.
%
%       OutputFiles - a PAFile array containing information about
%       output files that will be generated by this task remotely and copied back from the remote machine.
%
%       SelectionScript - a string containing the pathnames of a user
%       defined selection script (in languages such as Javascript, Ruby,
%       Python), see ProActive Scheduler documentation for more information.
%
%       Static - a boolean, true if the SelectionScript is a static one
%       (executed only once on a given machine), otherwise the
%       SelectionScript will be dynamic (default)
%
%       ScriptParams - a string containing the parameters of the custom script
%       delimited by spaces.
%
%       Compose - a boolean which defines if this task depends on the
%       result of the previous task(previous line) inside this PATask
%       column. If Compose is set to true, then the FIRST parameter of the
%       Func function will be taken from the result of the previous task,
%       subsequent parameters will be taken from the "Params" list.
%
%       NbNodes - an integer value which indicates the number of Scheduler
%       Nodes necessary to run this task. This parameter is interesting in
%       case the Matlab engine is running in multithreaded mode to specify
%       the number of processors necessary or if an external program is
%       called from the task, and this programs requires multiple
%       processors and/or machines. 
%   
%       Topology - a string parameter which affects how nodes will be chosen to meet
%       the NbNodes required. The values possible are : 'arbitrary',
%       'bestProximity', 'thresholdProximity', 'singleHost', 'singleHostExclusive',
%       'multipleHostsExclusive', 'differentHostsExclusive'
%       Please refer to ProActive Scheduler manual for more information on
%       these values.
%
%       ThresholdProximity - an integer value which indicates the threshold
%       in case the 'thresholdProximity' is set on the Topology attribute. Please 
%       refer to ProActive Scheduler manual for more information on this setting.
%       
%       In case the topology parameters are used, the remote matlab engines
%       can access the hostnames list of the Nodes used to run the task.
%       This hostnames list can then be used to run parallel code on those
%       machines. As multiple ProActive Nodes can be deployed on the same
%       host, the list may contain several times the same hostname. This
%       list will be assigned to the variable NODE_LIST in the workspace
%       calling the Func function. So, in order to retrieve this list,
%       you'll need to add the following code to your Matlab function:
%       nl = evalin('caller','NODE_LIST'); 
%        "nl" will be affected a cell array of strings. The first element of 
%       this list is always the Node where the function Func is executed.
%       The TestTopology function in the Tests folder provides an example
%       of topology usage.           
%
%       
% Examples
%
%       >> t = PATask(2,1);
%       >> t.Func = @factorial;
%       >> t(1,1).Params = {3};
%       >> t(2,1).Compose = true;
%       >> r = PAsolve(t);
%       >> val = PAwaitFor(r)
%       val =
%           720   % Result of factorial(factorial(3))
%
%
% See also
%       PAsolve, PAFile


% /*
%   * ################################################################
%   *
%   * ProActive Parallel Suite(TM): The Java(TM) library for
%   *    Parallel, Distributed, Multi-Core Computing for
%   *    Enterprise Grids & Clouds
%   *
%   * Copyright (C) 1997-2011 INRIA/University of
%   *                 Nice-Sophia Antipolis/ActiveEon
%   * Contact: proactive@ow2.org or contact@activeeon.com
%   *
%   * This library is free software; you can redistribute it and/or
%   * modify it under the terms of the GNU Affero General Public License
%   * as published by the Free Software Foundation; version 3 of
%   * the License.
%   *
%   * This library is distributed in the hope that it will be useful,
%   * but WITHOUT ANY WARRANTY; without even the implied warranty of
%   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   * Affero General Public License for more details.
%   *
%   * You should have received a copy of the GNU Affero General Public License
%   * along with this library; if not, write to the Free Software
%   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
%   * USA
%   *
%   * If needed, contact us to obtain a release under GPL Version 2 or 3
%   * or a different license than the AGPL.
%   *
%   *  Initial developer(s):               The ProActive Team
%   *                        http://proactive.inria.fr/team_members.htm
%   *  Contributor(s):
%   *
%   * ################################################################
%   * $$PROACTIVE_INITIAL_DEV$$
%   */
function varargout = PATask(lin, col)
persistent lastid
if exist('lastid','var') == 1 && isa(lastid,'int64')
    lastid=int64(double(lastid)+1);
else
    lastid = int64(0);
end
if exist('lin','var') == 1  && exist('col','var') == 1
    for i=1:lin
        for j=1:col
            this(i,j) = PATask();
        end
    end  
else
    this.Func = [];
    this.Params = {};
    this.Description = [];
    this.InputFiles = [];
    this.OutputFiles = [];
    this.Compose=false;
    this.SelectionScript = [];
    this.Static = false;
    this.ScriptParams = [];
    this.NbNodes = 1;
    this.Topology = [];
    this.ThresholdProximity = 0;
    this.id = lastid;
end
for i=1:nargout
    varargout{i}=[];
    if exist('lin','var') == 1  && exist('col','var') == 1
        varargout{i} = this;
    else
        varargout{i} = class(this,'PATask');
    end
end

