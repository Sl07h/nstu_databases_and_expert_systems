<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BD.aspx.cs" Inherits="bd_8.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server" dir="auto">
        <asp:Button ID="Button1" runat="server" OnClientClick="window.open('Request1.aspx');" Text="Запрос 1" />
        <asp:Button ID="Button2" runat="server" OnClientClick="window.open('Request2.aspx');" Text="Запрос 2" />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:studentsConnectionString_pmib6306 %>" ProviderName="<%$ ConnectionStrings:studentsConnectionString_pmib6306.ProviderName %>" SelectCommand="select *
from pmib6306.spj1"></asp:SqlDataSource>
    </form>
</body>
</html>
