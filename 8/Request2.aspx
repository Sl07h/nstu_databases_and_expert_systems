<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Request2.aspx.cs" Inherits="bd_8.Request2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        <asp:TextBox ID="TextBox1" runat="server" Text="2011-01-11" Width="150px"></asp:TextBox>
        <asp:DropDownList ID="DropDownList2" runat="server" Width="102px">
        </asp:DropDownList>
        <asp:TextBox ID="TextBox2" runat="server" Text="2013-01-11" Width="150px"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Показать" Width="102px" />
            <br />
            <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Увеличить количество в 2 раза" Width="260px" />
            <asp:Button ID="Button3" runat="server" OnClick="Button3_Click" Text="Уменьшить количество в 2 раза" Width="260px" />
        <asp:GridView ID="GridView2" runat="server" Width="539px"></asp:GridView>
            <br />
        <asp:Label ID="Label2" runat="server"></asp:Label>
        </div>
    </form>
</body>
</html>
