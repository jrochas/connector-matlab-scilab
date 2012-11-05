/*
 * ################################################################
 *
 * ProActive Parallel Suite(TM): The Java(TM) library for
 *    Parallel, Distributed, Multi-Core Computing for
 *    Enterprise Grids & Clouds
 *
 * Copyright (C) 1997-2012 INRIA/University of
 *                 Nice-Sophia Antipolis/ActiveEon
 * Contact: proactive@ow2.org or contact@activeeon.com
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License
 * as published by the Free Software Foundation; version 3 of
 * the License.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 * USA
 *
 * If needed, contact us to obtain a release under GPL Version 2 or 3
 * or a different license than the AGPL.
 *
 *  Initial developer(s):               The ProActive Team
 *                        http://proactive.inria.fr/team_members.htm
 *  Contributor(s):
 *
 * ################################################################
 * $$PROACTIVE_INITIAL_DEV$$
 */
package org.ow2.proactive.scheduler.ext.scilab.middleman;

import org.objectweb.proactive.api.PAActiveObject;
import org.ow2.proactive.scheduler.ext.matsci.client.common.MatSciEnvironment;
import org.ow2.proactive.scheduler.ext.matsci.middleman.MiddlemanDeployer;

import java.rmi.server.UnicastRemoteObject;


/**
 * MiddlemanDeployer a main class used to deploy the environment and dataspace dsregistry in the middleman JVM
 *
 * @author The ProActive Team
 */
public class ScilabMiddlemanDeployer extends MiddlemanDeployer {

    /**
     * Standalone objects
     */
    protected AOScilabEnvironment paenv_Scilab;

    /**
     * ProActive Stubs
     */
    protected AOScilabEnvironment pastub_paenv_Scilab;

    /**
     * RMI stubs
     */
    protected MatSciEnvironment rmistub_paenv_Scilab;

    protected void init() throws Exception {
        paenv_Scilab = new AOScilabEnvironment(debug);
        super.init(paenv_Scilab);
    }

    @Override
    protected void activate() throws Exception {
        super.activate();
        pastub_paenv_Scilab = PAActiveObject.turnActive(paenv_Scilab, mainNode);
    }

    @Override
    protected void terminateAO() throws Exception {
        paenv_Scilab.terminateFast();
        super.terminateAO();
    }

    @Override
    protected void unexportAll() throws Exception {
        UnicastRemoteObject.unexportObject(pastub_paenv_Scilab, true);
        super.unexportAll();
    }

    @Override
    protected void exportAll() throws Exception {
        rmistub_paenv_Scilab = (MatSciEnvironment) UnicastRemoteObject.exportObject(pastub_paenv_Scilab);
        super.exportAll();
    }

    @Override
    protected void rebindAll() throws Exception {
        super.rebindAll();
        registry.rebind(AOScilabEnvironment.class.getName(), rmistub_paenv_Scilab);

    }

    public static void main(String[] args) throws Exception {
        ScilabMiddlemanDeployer dep = new ScilabMiddlemanDeployer();
        dep.setPort(Integer.parseInt(System.getProperty("rmi.port")));
        dep.setDebug(Boolean.parseBoolean(args[0]));

        dep.submitMain();
    }
}
