package edu.ucla.library.libservices.invoicing.webservices.staff.web;

import edu.ucla.library.libservices.invoicing.webservices.staff.beans.StaffUser;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.UserRole;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.AssignUserRoleProcedure;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.GetStaffUserFunction;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.GetUserKeyFunction;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.InsertStaffUserProcedure;

import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.UpdateStaffUserProcedure;

import edu.ucla.library.libservices.invoicing.webservices.staff.generator.UserRoleGenerator;

import java.util.List;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

import org.springframework.jdbc.UncategorizedSQLException;

@Path( "/users/" )
public class StaffService
{
  @Context
  ServletConfig config;

  public StaffService()
  {
    super();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_user" )
  public Response addUser( UserRole data )
  {
    InsertStaffUserProcedure proc;
    proc = new InsertStaffUserProcedure();

    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.addUser();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "User creation failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_user" )
  public Response editUser( UserRole data )
  {
    UpdateStaffUserProcedure proc;
    proc = new UpdateStaffUserProcedure();

    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.editUser();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "User edit failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @GET
  @Produces( "application/xml, text/xml" )
  @Path( "user_info/{id}" )
  public StaffUser getUserInfo( @PathParam( "id" )
    String uid )
  {
    return getUser( uid,
                    config.getServletContext().getInitParameter( "datasource.invoice" ),
                    true );
  }

  @GET
  @Produces( "application/xml, text/xml" )
  @Path( "user_by_key/{id}" )
  public StaffUser getUserByKey( @PathParam( "id" )
    String idKey )
  {
    return getUser( idKey,
                    config.getServletContext().getInitParameter( "datasource.invoice" ),
                    false );
  }

  @GET
  @Produces( "text/plain" )
  @Path( "user_key/{id}" )
  public String getUserKey( @PathParam( "id" )
    String idKey )
  {
    GetUserKeyFunction getter;
    String crypto;

    getter = new GetUserKeyFunction();
    getter.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    getter.setIdKey( idKey );

    crypto = getter.getUser();

    return crypto;
  }

  public StaffUser getUserInfo( String uid, String dbName )
  {
    return getUser( uid, dbName, true );
  }

  public StaffUser getUserByKey( String idKey, String dbName )
  {
    return getUser( idKey, dbName, false );
  }

  private StaffUser getUser( String key, String db, boolean byUID )
  {
    GetStaffUserFunction getter;
    StaffUser theUser;
    String[] fields;

    getter = new GetStaffUserFunction();
    getter.setDbName( db );
    if ( byUID )
    {
      getter.setUserUid( key );
      getter.setByUid( true );
    }
    else
    {
      getter.setIdKey( key );
      getter.setByUid( false );
    }

    fields = getter.getUser().split( ":" );
    theUser = new StaffUser();
    theUser.setCryptoKey( fields[ 2 ] );
    theUser.setIdKey( fields[ 1 ] );
    theUser.setUserName( fields[ 0 ] );
    if ( fields.length == 4 )
      theUser.setRole( fields[ 3 ] );
    if ( byUID )
      theUser.setUserUid( key );

    if ( fields.length == 4 )
    {
      UserRoleGenerator generator;

      generator = new UserRoleGenerator();
      generator.setDbName( db );
      generator.setUserName( theUser.getUserName() );
      theUser.setPrivileges( generator.getPrivileges() );
    }

    return theUser;
  }

  @PUT
  @Path( "set_role/name/{un}/role/{rn}/whoby/{wb}" )
  public Response setRole( @PathParam( "un" )
    String userName, @PathParam( "rn" )
    String userRole, @PathParam( "wb" )
    String whoBy )
  {
    AssignUserRoleProcedure proc;
    proc = new AssignUserRoleProcedure();

    proc.setUserName( userName );
    proc.setUserRole( ( userRole.equalsIgnoreCase( "null" ) ? null:
                        userRole ) );
    proc.setWhoBy( whoBy );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.setRole();

      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Role assignment failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
  }

  @GET
  @Produces( "application/xml, text/xml" )
  @Path( "all_users" )
  public List<UserRole> getAllUsers()
  {
    UserRoleGenerator generator;
    generator = new UserRoleGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    return generator.getUsers();
  }

}
    /*proc.setUserName( userName );
    proc.setUserUid( uid );
    proc.setWhoBy( whoBy );
    if ( !ContentTests.isEmpty( userRole ) )
      proc.setUserRole( userRole.split( "/" )[ 2 ] );*/
    //proc.setUserName( userName );
    //proc.setWhoBy( whoBy );
    //import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
