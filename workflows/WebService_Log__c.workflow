<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_on_error</fullName>
        <description>Send email on webservice log error</description>
        <protected>false</protected>
        <recipients>
            <recipient>integrationframework@capgemini.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_on_error</template>
    </alerts>
    <rules>
        <fullName>Status Log Alert</fullName>
        <actions>
            <name>Send_email_on_error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>WebService_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>E</value>
        </criteriaItems>
        <criteriaItems>
            <field>WebService_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>I</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
