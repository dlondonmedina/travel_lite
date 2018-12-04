/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package queryrunner;

import java.util.ArrayList;

/**
 * 
 * QueryRunner takes a list of Queries that are initialized in it's constructor
 * and provides functions that will call the various functions in the QueryJDBC class 
 * which will enable MYSQL queries to be executed. It also has functions to provide the
 * returned data from the Queries. Currently the eventHandlers in QueryFrame call these
 * functions in order to run the Queries.
 */
public class QueryRunner {

    
    private static final String APPLICATION_NAME = "Travel Lite";
 
	public QueryRunner()
    {
        this.m_jdbcData = new QueryJDBC();
        m_updateAmount = 0;
        m_queryArray = new ArrayList<>();
        m_error="";
        
        this.m_projectTeamApplication=APPLICATION_NAME;    // THIS NEEDS TO CHANGE FOR YOUR APPLICATION
        
        // Each row that is added to m_queryArray is a separate query. It does not work on Stored procedure calls.
        // The 'new' Java keyword is a way of initializing the data that will be added to QueryArray. Please do not change
        // Format for each row of m_queryArray is: (QueryText, ParamaterLabelArray[], LikeParameterArray[], IsItActionQuery, IsItParameterQuery)
        
        //    QueryText is a String that represents your query. It can be anything but Stored Procedure
        //    Parameter Label Array  (e.g. Put in null if there is no Parameters in your query, otherwise put in the Parameter Names)
        //    LikeParameter Array  is an array I regret having to add, but it is necessary to tell QueryRunner which parameter has a LIKE Clause. If you have no parameters, put in null. Otherwise put in false for parameters that don't use 'like' and true for ones that do.
        //    IsItActionQuery (e.g. Mark it true if it is, otherwise false)
        //    IsItParameterQuery (e.g.Mark it true if it is, otherwise false)
        
        m_queryArray.add(new QueryData("Select concat(traveler_first_name, ' ', traveler_last_name) as 'Traveler' from traveler;", null, null, false, false)); // Get all travelers
        m_queryArray.add(new QueryData("Select * from traveler where (traveler_last_name = ?) and (traveler_first_name = ?);", new String [] {"Last Name", "First Name"}, new boolean [] {false, false}, false, true)); // find a traveler by name
        m_queryArray.add(new QueryData("Select concat(traveler_first_name, ' ', traveler_last_name) as 'Traveler' from flight f "
        		+ "join connection c on f.flight_id = c.flight_id "
        		+ "join trip t on c.trip_id = t.trip_id "
        		+ "join reservation r on t.trip_id = r.trip_id "
        		+ "join traveler t2 on r.traveler_id = t2.traveler_id "
        		+ "where f.flight_id = ?;", new String [] {"FLIGHT_NUMBER"}, new boolean[] {false}, false, true)); // Get travelers on a single flight
        m_queryArray.add(new QueryData("Select date_format(reservation_date_time, '%M %Y') as 'Booking Date', count(*) as '# bookings' "
        		+ "from reservation r where r.reservation_date_time > cast(? as date) group by date_format(reservation_date_time, '%M %Y');", new String [] {"Since (YYYY-MM-DD"}, new boolean [] {false}, false, true)); // Get number of bookings grouped by month since date.
        
        m_queryArray.add(new QueryData("insert into contact (contact_id, contact_name, contact_salary) values (?,?,?)",new String [] {"CONTACT_ID", "CONTACT_NAME", "CONTACT_SALARY"}, new boolean [] {false, false, false}, true, true));// THIS NEEDS TO CHANGE FOR YOUR APPLICATION
        m_queryArray.add(new QueryData("SELECT CONCAT(traveler_first_name, ' ', " + 
        		"traveler_last_name) AS 'Traveler', " + 
        		"DATE_FORMAT(r.reservation_date_time, '%a %b %e %Y') AS 'Booking Date', " + 
        		"TIME_FORMAT(r.reservation_date_time, '%h:%i %p')    AS 'Booking Time' " + 
        		"FROM traveler t " + 
        		"JOIN reservation r on t.traveler_id = r.traveler_id " + 
        		"WHERE r.reservation_date_time > DATE_SUB(NOW(), INTERVAL ? DAY);", new String [] {"Day Interval"}, new boolean [] {false}, false, true)); // List all travelers who booked a trip since a set time. 
        m_queryArray.add(new QueryData("SELECT CONCAT(traveler_first_name, ' ', " + 
        		"traveler_last_name)       AS 'Traveler', " + 
        		"DATE_FORMAT(card.payment_card_expiration_date, '%m/%y') AS 'Card Expiration Date', " + 
        		"card.payment_card_number AS 'Card Number', " + 
        		"t2.payment_card_type_description AS 'Card Type' " + 
        		"FROM traveler t " + 
        		"JOIN payment_card card on t.traveler_id = card.customer_id " + 
        		"JOIN payment_card_type t2 " + 
        		"on card.payment_card_type_id = t2.payment_card_type_id " + 
        		"WHERE card.payment_card_expiration_date < DATE_ADD(NOW(), INTERVAL ? DAY);", new String [] {"Day Interval"}, new boolean [] {false}, false, true)); // List all travelers with credit cards expiring within Day Interval
        m_queryArray.add(new QueryData("Select airport_iata_code as 'IATA Code', airport_name as 'Airport', city_name as 'City', state_name_abbreviation as 'State' "
        		+ "from airport a "
        		+ "join city c on a.city_id = c.city_id "
        		+ "join state s on c.state_id = s.state_id "
        		+ "where state_name_abbreviation in ? order by state_name_abbreviation, airport_iata_code;", new String [] {"State Abbreviation"}, new boolean [] {false}, false, true)); // list all airports within a states
        m_queryArray.add(new QueryData("Insert into traveler values (DEFAULT, ?, ?);", new String[] {"First Name", "Last Name"}, new boolean [] {false, false}, true, true)); // add traveler
    }
       

    public int GetTotalQueries()
    {
        return m_queryArray.size();
    }
    
    public int GetParameterAmtForQuery(int queryChoice)
    {
        QueryData e=m_queryArray.get(queryChoice);
        return e.GetParmAmount();
    }
              
    public String  GetParamText(int queryChoice, int parmnum )
    {
       QueryData e=m_queryArray.get(queryChoice);        
       return e.GetParamText(parmnum); 
    }   

    public String GetQueryText(int queryChoice)
    {
        QueryData e=m_queryArray.get(queryChoice);
        return e.GetQueryString();        
    }
    
    /**
     * Function will return how many rows were updated as a result
     * of the update query
     * @return Returns how many rows were updated
     */
    
    public int GetUpdateAmount()
    {
        return m_updateAmount;
    }
    
    /**
     * Function will return ALL of the Column Headers from the query
     * @return Returns array of column headers
     */
    public String [] GetQueryHeaders()
    {
        return m_jdbcData.GetHeaders();
    }
    
    /**
     * After the query has been run, all of the data has been captured into
     * a multi-dimensional string array which contains all the row's. For each
     * row it also has all the column data. It is in string format
     * @return multi-dimensional array of String data based on the resultset 
     * from the query
     */
    public String[][] GetQueryData()
    {
        return m_jdbcData.GetData();
    }

    public String GetProjectTeamApplication()
    {
        return m_projectTeamApplication;        
    }
    public boolean  isActionQuery (int queryChoice)
    {
        QueryData e=m_queryArray.get(queryChoice);
        return e.IsQueryAction();
    }
    
    public boolean isParameterQuery(int queryChoice)
    {
        QueryData e=m_queryArray.get(queryChoice);
        return e.IsQueryParm();
    }
    
     
    public boolean ExecuteQuery(int queryChoice, String [] parms)
    {
        boolean bOK = true;
        QueryData e=m_queryArray.get(queryChoice);        
        bOK = m_jdbcData.ExecuteQuery(e.GetQueryString(), parms, e.GetAllLikeParams());
        return bOK;
    }
    
     public boolean ExecuteUpdate(int queryChoice, String [] parms)
    {
        boolean bOK = true;
        QueryData e=m_queryArray.get(queryChoice);        
        bOK = m_jdbcData.ExecuteUpdate(e.GetQueryString(), parms);
        m_updateAmount = m_jdbcData.GetUpdateCount();
        return bOK;
    }   
    
      
    public boolean Connect(String szHost, String szUser, String szPass, String szDatabase)
    {

        boolean bConnect = m_jdbcData.ConnectToDatabase(szHost, szUser, szPass, szDatabase);
        if (bConnect == false)
            m_error = m_jdbcData.GetError();        
        return bConnect;
    }
    
    public boolean Disconnect()
    {
        // Disconnect the JDBCData Object
        boolean bConnect = m_jdbcData.CloseDatabase();
        if (bConnect == false)
            m_error = m_jdbcData.GetError();
        return true;
    }
    
    public String GetError()
    {
        return m_error;
    }
 
    private QueryJDBC m_jdbcData;
    private String m_error;    
    private String m_projectTeamApplication;
    private ArrayList<QueryData> m_queryArray;  
    private int m_updateAmount;
            
    /**
     * @param args the command line arguments
     */
    
    // Console App will Connect to Database
    // It will run a single select query without Parameters
    // It will display the results
    // It will close the database session
    
    public static void main(String[] args) {
        // TODO code application logic here

        final QueryRunner queryrunner = new QueryRunner();
        
        if (args.length == 0)
        {
            java.awt.EventQueue.invokeLater(new Runnable() {
                public void run() {

                    new QueryFrame(queryrunner).setVisible(true);
                }            
            });
        }
        else
        {
            if (args[0] == "-console")
            {
                // TODO 
                // You should code the following functionality:

                //    You need to determine if it is a parameter query. If it is, then
                //    you will need to ask the user to put in the values for the Parameters in your query
                //    you will then call ExecuteQuery or ExecuteUpdate (depending on whether it is an action query or regular query)
                //    if it is a regular query, you should then get the data by calling GetQueryData. You should then display this
                //    output. 
                //    If it is an action query, you will tell how many row's were affected by it.
                // 
                //    This is Psuedo Code for the task:  
                //    Connect()
                //    n = GetTotalQueries()
                //    for (i=0;i < n; i++)
                //    {
                //       Is it a query that Has Parameters
                //       Then
                //           amt = find out how many parameters it has
                //           Create a paramter array of strings for that amount
                //           for (j=0; j< amt; j++)
                //              Get The Paramater Label for Query and print it to console. Ask the user to enter a value
                //              Take the value you got and put it into your parameter array
                //           If it is an Action Query then
                //              call ExecuteUpdate to run the Query
                //              call GetUpdateAmount to find out how many rows were affected, and print that value
                //           else
                //               call ExecuteQuery 
                //               call GetQueryData to get the results back
                //               print out all the results
                //           end if
                //      }
                //    Disconnect()


                // NOTE - IF THERE ARE ANY ERRORS, please print the Error output
                // NOTE - The QueryRunner functions call the various JDBC Functions that are in QueryJDBC. If you would rather code JDBC
                // functions directly, you can choose to do that. It will be harder, but that is your option.
                // NOTE - You can look at the QueryRunner API calls that are in QueryFrame.java for assistance. You should not have to 
                //    alter any code in QueryJDBC, QueryData, or QueryFrame to make this work.
                System.out.println("Please write the non-gui functionality");
            }
            else
            {
               System.out.println("usage: you must use -console as your argument to get non-gui functionality. If you leave it out it will be GUI");
            }
        }

    }    
}
