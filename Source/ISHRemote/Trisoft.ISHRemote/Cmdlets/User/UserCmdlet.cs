/*
* Copyright (c) 2014 All Rights Reserved by the SDL Group.
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
*     http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

using System;
using System.Management.Automation;
using Trisoft.ISHRemote.Objects;
using Trisoft.ISHRemote.Objects.Public;
using Trisoft.ISHRemote.Exceptions;

namespace Trisoft.ISHRemote.Cmdlets.User
{
    public abstract class UserCmdlet : TrisoftCmdlet
    {
        /// <summary>
        /// Add the required fields to the requested metadata so when piping the object the necesarry identifiers are provided.
        /// </summary>
        /// <param name="currentFields">The current <see cref="IshFields"/> object to append.</param>
        /// <returns>The updated <see cref="IshFields"/> object.</returns>
        public virtual IshFields AddRequiredFields(IshFields currentFields)
        {
            currentFields.AddOrUpdateField(new IshRequestedMetadataField("USERNAME", Enumerations.Level.None, Enumerations.ValueType.Value));
            return currentFields;
        }

        /// <summary>
        /// Removes the SYSTEM fields from the given IshFields container. Making the fields ready for an update/write operation. 
        /// </summary>
        internal override IshFields RemoveSystemFields(IshFields ishFields, Enumerations.ActionMode actionMode)
        {
            if (actionMode == Enumerations.ActionMode.Read)
            {
                throw new InvalidOperationException(
                    "We will not remove system fields for read operations anymore as part of TS-9581");
            }

            const Enumerations.Level level = Enumerations.Level.None;
            const Enumerations.ValueType valueType = Enumerations.ValueType.All;

            if (actionMode == Enumerations.ActionMode.Create)
            {
                // Allow the update to change these fields for rename
                ishFields.RemoveField(FieldElements.UserName, level, valueType);
                ishFields.RemoveField(FieldElements.Name, level, valueType);

                // When creating the user, the user is always active..so, the value cannot be set during creation
                ishFields.RemoveField(FieldElements.ObjectActive, level, valueType);
                ishFields.RemoveField(FieldElements.UserDisabled, level, valueType);

                // User locked field
                ishFields.RemoveField(FieldElements.UserLocked, level, valueType);
            }

            // Specific for Update in Trisoft.ISHRemote
            if (actionMode == Enumerations.ActionMode.Update)
            {
                ishFields.RemoveField(FieldElements.UserName, level, Enumerations.ValueType.Id);
                ishFields.RemoveField(FieldElements.UserName, level, Enumerations.ValueType.Element);
            }

            if (actionMode == Enumerations.ActionMode.Create || actionMode == Enumerations.ActionMode.Update)
            {
                //  These fields can be retrieved BUT cannot be set 

                // User fields
                ishFields.RemoveField(FieldElements.Rights, level, valueType);

                // General date fields
                ishFields.RemoveField(FieldElements.CreationDate, level, valueType);
                ishFields.RemoveField(FieldElements.ModificationDate, level, valueType);

                // User authentication fields   
                ishFields.RemoveField(FieldElements.UserPasswordModifiedOn, level, valueType);
                ishFields.RemoveField(FieldElements.UserLastLoginOn, level, valueType);
                ishFields.RemoveField(FieldElements.UserFailedAttempts, level, valueType);
                ishFields.RemoveField(FieldElements.UserLockedSince, level, valueType);
            }

            if (actionMode == Enumerations.ActionMode.Read)
            {
                // The password field cannot be retrieved BUT can be set by an administrator
                ishFields.RemoveField(FieldElements.Password, level, valueType);
            }          

            // The field FISHFAVORITES is an internal field and cannot be accessed
            ishFields.RemoveField(FieldElements.Favorites, level, valueType);

            // General security fields
            ishFields.RemoveField(FieldElements.ReadAccess, level, valueType);
            ishFields.RemoveField(FieldElements.ModifyAccess, level, valueType);
            ishFields.RemoveField(FieldElements.DeleteAccess, level, valueType);
            ishFields.RemoveField(FieldElements.Owner, level, valueType);

            // Password salt and password history fields are not retrievable or updatable
            ishFields.RemoveField(FieldElements.UserPasswordSalt, level, valueType);
            ishFields.RemoveField(FieldElements.UserPasswordHistory, level, valueType);

            return ishFields;
        }
    }
}