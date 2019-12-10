using System;
using System.Data;
using System.Data.Odbc;


namespace bd_8
{
    public partial class Request2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Reload();
        }

        protected void Request_2()
        {
            //Label2.Text = "";
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();

            // Определяем строку с текстом запроса
            string strSQL = @"  -- Просмотр
                                select *
                                from pmib6306.spj1
                                where n_post = ? and date_post between ? and ?;
                              ";



            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // Создаем первый параметр
            OdbcParameter par1 = new OdbcParameter();
            par1.ParameterName = "@vn_post";
            par1.OdbcType = OdbcType.Text;
            par1.Value = DropDownList2.SelectedValue;
            //Добавляем первый параметр в коллекцию
            cmd.Parameters.Add(new OdbcParameter("@vn_post", DropDownList2.SelectedValue));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox1.Text));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox2.Text));
            // Объявляем объект транзакции
            OdbcTransaction tx = null;
            try
            {
                // Начинаем транзакцию и извлекаем объект транзакции из объекта подключения.
                tx = conn.BeginTransaction();
                // Включаем объект SQL-команды в транзакцию
                cmd.Transaction = tx;
                // Выполняем SQL-команду и получаем количество обработанных записей
                OdbcDataReader res = cmd.ExecuteReader();

                DataTable result_table = new DataTable();

                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Номер поставки";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Номер поставщика";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Номер детали";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Номер изделия";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Количество";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Дата поставки";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Цена";
                    result_table.Columns.Add(fNameColumn);
                }
                while (res.Read())
                {
                    DataRow new_row;
                    new_row = result_table.NewRow();
                    new_row["Номер поставки"] = res[0];
                    new_row["Номер поставщика"] = res[1];
                    new_row["Номер детали"] = res[2];
                    new_row["Номер изделия"] = res[3];
                    new_row["Количество"] = res[4];
                    new_row["Дата поставки"] = res[5];
                    new_row["Цена"] = res[6];

                    result_table.Rows.Add(new_row);
                }
                // Подтверждаем транзакцию  
                GridView2.DataSource = result_table;
                GridView2.DataBind();
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label2.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }

            //закрываем соединение
            conn.Close();
        }

        protected void Request_3()
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();

            // Определяем строку с текстом запроса
            string strSQL = @"  -- Удвоение числа деталей
                                update pmib6306.spj1
                                set kol = kol * 2
                                where n_post = ? and date_post between ? and ?;
                              ";



            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // Создаем первый параметр
            OdbcParameter par1 = new OdbcParameter();
            par1.ParameterName = "@vn_post";
            par1.OdbcType = OdbcType.Text;
            par1.Value = DropDownList2.SelectedValue;
            //Добавляем первый параметр в коллекцию
            cmd.Parameters.Add(new OdbcParameter("@vn_post", DropDownList2.SelectedValue));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox1.Text));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox2.Text));
            // Объявляем объект транзакции
            OdbcTransaction tx = null;
            try
            {
                // Начинаем транзакцию и извлекаем объект транзакции из объекта подключения.
                tx = conn.BeginTransaction();
                // Включаем объект SQL-команды в транзакцию
                cmd.Transaction = tx;
                // Выполняем SQL-команду и получаем количество обработанных записей
                OdbcDataReader res = cmd.ExecuteReader();
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label2.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }

            //закрываем соединение
            conn.Close();
        }

        protected void Request_4()
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();

            // Определяем строку с текстом запроса
            string strSQL = @"  -- Удвоение числа деталей
                                update pmib6306.spj1
                                set kol = kol / 2
                                where n_post = ? and date_post between ? and ?;
                              ";



            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // Создаем первый параметр
            OdbcParameter par1 = new OdbcParameter();
            par1.ParameterName = "@vn_post";
            par1.OdbcType = OdbcType.Text;
            par1.Value = DropDownList2.SelectedValue;
            //Добавляем первый параметр в коллекцию
            cmd.Parameters.Add(new OdbcParameter("@vn_post", DropDownList2.SelectedValue));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox1.Text));
            cmd.Parameters.Add(new OdbcParameter("@vdate_post", TextBox2.Text));
            // Объявляем объект транзакции
            OdbcTransaction tx = null;
            try
            {
                // Начинаем транзакцию и извлекаем объект транзакции из объекта подключения.
                tx = conn.BeginTransaction();
                // Включаем объект SQL-команды в транзакцию
                cmd.Transaction = tx;
                // Выполняем SQL-команду и получаем количество обработанных записей
                OdbcDataReader res = cmd.ExecuteReader();
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label2.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }

            //закрываем соединение
            conn.Close();
        }
        
        protected void FillDropDownList2()
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();
            string strSQL = "select n_post from pmib6306.s";
            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            OdbcTransaction tx = null;
            try
            {
                // Начинаем транзакцию и извлекаем объект транзакции из объекта подключения.
                tx = conn.BeginTransaction();
                // Включаем объект SQL-команды в транзакцию
                cmd.Transaction = tx;
                // Выполняем SQL-команду и получаем количество обработанных записей
                OdbcDataReader res = cmd.ExecuteReader();

                while (res.Read())
                    DropDownList2.Items.Add(res[0].ToString());

                // Подтверждаем транзакцию  
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label2.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }
            //закрываем соединение
            conn.Close();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Request_2();
            Reload();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Request_3();
            Reload();
            Button1_Click(sender, e);
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            Request_4();
            Reload();
            Button1_Click(sender, e);
        }

        private void Reload()
        {
            var SelVal = DropDownList2.SelectedValue;
            DropDownList2.Items.Clear();
            FillDropDownList2();
            DropDownList2.SelectedValue = SelVal;
        }
    }
}