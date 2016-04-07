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
package org.ow2.proactive.scheduler.ext.matsci.client.common.data;

import java.io.Serializable;
import java.util.Comparator;


/**
 * TaskNameComparator
 *
 * @author The ProActive Team
 */
public class TaskNameComparator implements Comparator<String>, Serializable {

    private static final long serialVersionUID = 13L;

    public TaskNameComparator() {

    }

    public int compare(String o1, String o2) {
        if (o1 == null && o2 == null)
            return 0;
        // assuming you want null values shown last
        if (o1 != null && o2 == null)
            return -1;
        if (o1 == null && o2 != null)
            return 1;
        int answer = 0;
        try {
            String[] arr1 = o1.split("_");
            String[] arr2 = o2.split("_");
            answer = Integer.parseInt(arr1[1]) - Integer.parseInt(arr2[1]);
            if (answer == 0) {
                answer = Integer.parseInt(arr1[0]) - Integer.parseInt(arr2[0]);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return answer;
    }
}
