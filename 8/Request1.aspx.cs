﻿using System;
using System.Data;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Forms;

namespace bd_8
{
    public partial class Request1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Reload();
        }
        
        protected void Request_1()
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();

            // Определяем строку с текстом запроса
            string strSQL = @"  -- Получить информацию о выручке поставщиков, сделавших больше всего поставок
                                -- для указанного изделия
                                select n_post, sum(t2.kol*t2.cost) as revenue
                                from pmib6306.spj1 t2
                                where t2.n_post = ( -- максимальное число поставленных деталей
                                                    select t1.n_post
                                                    from pmib6306.spj1 t1
                                                    where t1.n_izd = ?
                                                    group by t1.n_post
                                                    order by sum(t1.kol) desc
                                                    limit 1 )
                                group by t2.n_post
                              ";



            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // Создаем первый параметр
            OdbcParameter par1 = new OdbcParameter();
            par1.ParameterName = "@vn_izd";
            par1.OdbcType = OdbcType.Text;
            par1.Value = DropDownList1.SelectedValue;
            //Добавляем первый параметр в коллекцию
            cmd.Parameters.Add(new OdbcParameter("@vn_izd", DropDownList1.SelectedValue));
            cmd.Parameters.Add(new OdbcParameter("@vn_izd", DropDownList1.SelectedValue));
            cmd.Parameters.Add(new OdbcParameter("@vn_izd", DropDownList1.SelectedValue));
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
                    fNameColumn.ColumnName = "Номер поставщика";
                    result_table.Columns.Add(fNameColumn);
                }
                using (DataColumn fNameColumn = new DataColumn())
                {
                    fNameColumn.DataType = System.Type.GetType("System.String");
                    fNameColumn.ColumnName = "Выручка";
                    result_table.Columns.Add(fNameColumn);
                }
                while (res.Read())
                {
                    DataRow new_row;
                    new_row = result_table.NewRow();
                    new_row["Номер поставщика"] = res[0];
                    new_row["Выручка"] = res[1];

                    result_table.Rows.Add(new_row);
                }
                // Подтверждаем транзакцию  
                GridView1.DataSource = result_table;
                GridView1.DataBind();
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label1.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }

            //закрываем соединение
            conn.Close();
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();

            // Определяем строку с текстом запроса
            //string strSQL = "UPDATE pmib6306.p SET name = ?  where  n_det = ? ";
            string strSQL = "select * from pmib6306.spj1";
            // Создаем объект запроса
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // Создаем первый параметр
            OdbcParameter par_name = new OdbcParameter();
            par_name.ParameterName = "@vname";
            par_name.OdbcType = OdbcType.Text;
            par_name.Value = "Кулер";
            // Добавляем первый параметр в коллекцию
            // cmd.Parameters.Add(par_name);
            // Создаем второй параметр
            OdbcParameter par_town = new OdbcParameter();
            par_town.ParameterName = "@vn_det";
            par_town.OdbcType = OdbcType.Text;
            par_town.Value = "P3";
            // Добавляем второй параметр в коллекцию.
            //  cmd.Parameters.Add(par_town);
            // Объявляем объект транзакции
            OdbcTransaction tx = null;
            try
            {
                // Начинаем транзакцию и извлекаем объект транзакции из объекта подключения.
                tx = conn.BeginTransaction();
                // Включаем объект SQL-команды в транзакцию
                cmd.Transaction = tx;
                // Выполняем SQL-команду и получаем количество обработанных записей
                int i = cmd.ExecuteNonQuery();
                // Подтверждаем транзакцию  
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label1.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }

            //закрываем соединение
            conn.Close();
        }

        protected void FillDropDownList1()
        {
            // Создаем объект подключения
            OdbcConnection conn = new OdbcConnection();
            // Задаем параметр подключения – имя ODBC-источника
            conn.ConnectionString = "Dsn=PostgreSQL30;database=students;server=students.ami.nstu.ru;port=5432;uid=pmi-b6306;pwd=Jemlift5;sslmode=disable;readonly=0;protocol=7.4;fakeoidindex=0;showoidcolumn=0;rowversioning=0;showsystemtables=0;fetch=100;unknownsizes=0;maxvarcharsize=255;maxlongvarcharsize=8190;debug=0;commlog=0;usedeclarefetch=0;textaslongvarchar=1;unknownsaslongvarchar=0;boolsaschar=1;parse=0;lfconversion=1;updatablecursors=1;trueisminus1=0;bi=0;byteaaslongvarbinary=1;useserversideprepare=1;lowercaseidentifier=0;d6=-101;xaopt=1";
            // Подключаемся к БД
            conn.Open();
            string strSQL = "select n_izd from pmib6306.j";
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
                    DropDownList1.Items.Add(res[0].ToString());

                // Подтверждаем транзакцию  
                tx.Commit();
            }
            catch (Exception ex)
            {
                // При возникновении любой ошибки 
                // Формируем сообщение об ошибке 
                Label1.Text = ex.Message;
                // выполняем откат транзакции 
                tx.Rollback();
            }
            //закрываем соединение
            conn.Close();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Request_1();
            Reload();
        }

        private void Reload()
        {
            var SelVal = DropDownList1.SelectedValue;
            DropDownList1.Items.Clear();
            FillDropDownList1();
            DropDownList1.SelectedValue = SelVal;
        }

        
    }
}