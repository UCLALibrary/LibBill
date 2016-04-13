<%
Public Function bIsInArray(ByRef FindValue, ByRef vArr)
    Dim vArrEach
    For Each vArrEach In vArr
        If IsObject(FindValue) Then
            bIsInArray = FindValue Is vArrEach
        Else
            bIsInArray = (FindValue = vArrEach)
        End If
        If bIsInArray Then Exit For
    Next
End Function

Public Function loadXMLFile(strXMLFile, strXSLFile)

 'Declare local variables
 Dim objXML
 Dim objXSL

 'Instantiate the XMLDOM Object that will hold the XML file.
 set objXML = Server.CreateObject("Microsoft.XMLDOM")

 'Turn off asyncronous file loading.
 objXML.async = false

 'Load the XML file.
 objXML.load(strXMLFile)

 'Instantiate the XMLDOM Object that will hold the XSL file.
 set objXSL = Server.CreateObject("Microsoft.XMLDOM")

 'Turn off asyncronous file loading.
 objXSL.async = false

 'Load the XSL file.
 objXSL.load(strXSLFile)

 'Use the "transformNode" method of the XMLDOM to apply the XSL
 'stylesheet to the XML document. Then the output is written to the client.
 Response.Write(objXML.transformNode(objXSL))
 'response.write "hello..."
End Function

%>