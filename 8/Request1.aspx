<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Request1.aspx.cs" Inherits="bd_8.Request1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True"></asp:DropDownList>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Показать" />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True" Width="544px" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
        </asp:GridView>
        </div>
    </form>
</body>
</html>
