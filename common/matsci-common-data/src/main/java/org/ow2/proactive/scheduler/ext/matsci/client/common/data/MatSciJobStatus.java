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

/**
 * MatSciJobStatus a clone of the scheduler MatSciJobStatus used here to avoid class downloading
 *
 * @author The ProActive Team
 */
public enum MatSciJobStatus implements java.io.Serializable {
    /**
     * The job is waiting to be scheduled.
     */
    PENDING("Pending"),
    /**
     * The job is running. Actually at least one of its task has been scheduled.
     */
    RUNNING("Running"),
    /**
     * The job has been launched but no task are currently running.
     */
    STALLED("Stalled"),
    /**
     * The job is finished. Every tasks are finished.
     */
    FINISHED("Finished"),
    /**
     * The job is paused waiting for user to resume it.
     */
    PAUSED("Paused"),
    /**
     * The job has been canceled due to user exception and order.
     * This status runs when a user exception occurs in a task
     * and when the user has asked to cancel On exception.
     */
    CANCELED("Canceled"),
    /**
     * The job has failed. One or more tasks have failed (due to resources failure).
     * There is no more executionOnFailure left for a task.
     */
    FAILED("Failed"),
    /**
     * The job has been killed by a user..
     * Nothing can be done anymore on this job expect read execution informations
     * such as output, time, etc...
     */
    KILLED("Killed"),

    /**
     * The job is unknown by the scheduler..
     */
    UNKNOWN("Unknown");

    /** The textual definition of the status */
    private String definition;

    /**
     * Default constructor.
     * @param def the textual definition of the status.
     */
    MatSciJobStatus(String def) {
        definition = def;
    }

    /**
     * @see Enum#toString()
     */
    @Override
    public String toString() {
        return definition;
    }

    public static MatSciJobStatus getJobStatus(String status) {
        for (MatSciJobStatus s : MatSciJobStatus.values()) {
            if (s.toString().equals(status)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Wrong status : " + status);
    }

}
