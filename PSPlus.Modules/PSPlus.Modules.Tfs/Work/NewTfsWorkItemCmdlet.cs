﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using Microsoft.TeamFoundation.WorkItemTracking.Client;
using PSPlus.Tfs.TfsUtils;
using PSPlus.Tfs.WIQLUtils;

namespace PSPlus.Modules.Tfs.Work
{
    [Cmdlet(VerbsCommon.New, "TfsWorkItem")]
    [OutputType(typeof(WorkItem))]
    public class NewTfsWorkItemCmdlet : TfsProjectCmdletBase
    {
        [Parameter(Position = 0, ValueFromPipelineByPropertyName = true, Mandatory = true, HelpMessage = "Work item type.")]
        [Alias("t")]
        public object Type { get; set; }

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = true, Mandatory = true, HelpMessage = "Work item title.")]
        public string Title { get; set; }

        [Parameter(ValueFromPipelineByPropertyName = true, Mandatory = false, HelpMessage = "Assigned to.")]
        [Alias("at")]
        public string AssignedTo { get; set; }

        [Parameter(ValueFromPipelineByPropertyName = true, Mandatory = false, HelpMessage = "Area path.")]
        [Alias("ap", "Area")]
        public string AreaPath { get; set; }

        [Parameter(ValueFromPipelineByPropertyName = true, Mandatory = false, HelpMessage = "Iteration path.")]
        [Alias("ip", "Iteration")]
        public string IterationPath { get; set; }

        [Parameter(ValueFromPipelineByPropertyName = true, Mandatory = false, HelpMessage = "Other properties.")]
        public Hashtable Properties { get; set; }

        protected override void ProcessRecordInEH()
        {
            Project project = EnsureProject();

            WorkItemType workItemType = EnsureWorkItemType(Project);

            WorkItem workItem = workItemType.NewWorkItem();
            workItem.Title = Title;

            if (!string.IsNullOrEmpty(AssignedTo))
            {
                workItem.Fields[WIQLSystemFieldNames.AssignedTo].Value = AssignedTo;
            }

            if (!string.IsNullOrEmpty(AreaPath))
            {
                workItem.AreaPath = AreaPath;
            }

            if (!string.IsNullOrEmpty(IterationPath))
            {
                workItem.IterationPath = IterationPath;
            }

            if (Properties != null)
            {
                foreach (DictionaryEntry property in Properties)
                {
                    string propertyKey = property.Key as string;

                    Field propertyValue = workItem.Fields[propertyKey];
                    if (propertyValue == null)
                    {
                        throw new ArgumentException(string.Format("Unexpected property: {0}.", propertyKey));
                    }

                    propertyValue.Value = property.Value;
                }
            }

            ArrayList validateResults = workItem.Validate();
            if (validateResults.Count > 0)
            {
                StringBuilder validateResultMessage = new StringBuilder();
                validateResultMessage.AppendLine("Work item validation failed!");
                validateResultMessage.AppendLine("Invaild fields are listed below:");

                foreach (Field field in validateResults)
                {
                    validateResultMessage.AppendFormat("- Field \"{0}\": {1}.", field.Name, field.Status.ToString());
                }

                throw new InvalidOperationException(validateResultMessage.ToString());
            }

            workItem.Save();

            WriteObject(workItem);
        }

        private WorkItemType EnsureWorkItemType(Project project)
        {
            if (Type is WorkItemType)
            {
                return Type as WorkItemType;
            }
            else if (Type is string)
            {
                string workItemTypeName = Type as string;

                List<WorkItemType> workItemTypes = project.GetWorkItemTypes(workItemTypeName).ToList();
                if (workItemTypes.Count == 0)
                {
                    throw new ArgumentException(string.Format("Invalid work item type: {0}.", workItemTypeName));
                }
                else if (workItemTypes.Count > 1)
                {
                    throw new ArgumentException(string.Format("More than 1 work item types are matched with type: {0}.", workItemTypeName));
                }

                return workItemTypes[0];
            }

            throw new ArgumentException("The type of WorkItemType must be WorkItemType or string.");
        }
    }
}