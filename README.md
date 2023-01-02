# asf_php_docker
Configuracion del docker para Aplicacion ASF PHP codigo sin framework
Correr imagen con:
docker-compose up -d --build
Lo que yo estoy haciendo para probar es agregar estas lineas cuando se va a ejecutar un SP:
        $ConS = new ConexionSQL();
		$IdBd = $ConS->conOpen();
las agrego antes de la llamada del SP
ejemplo:

/**
	 * Obtener array de notificaciones, del usuario enviado
	 * @param $User Usuario a consultar
	 * @param $Unread Si solo se desea consultar notificaciones sin leer
	 * @param $Last Si es 1 indica que se deben obtener las ultimas notificaciones 
	 * @return array de objetos Notificacion
	 */
	public static final function getNotification($IdBd,$User,$Unread = 1,$Last = 1){
		$ListNot = array();
		$ConS = new ConexionSQL();
		$IdBd = $ConS->conOpen();
		$stmt = mssql_init('cNotificacion',$IdBd);
		
		mssql_bind($stmt,'@Usuario',$User,SQLVARCHAR);
		mssql_bind($stmt,'@Unread',$Unread,SQLINT4);
		mssql_bind($stmt,'@Last',$Last,SQLINT4);
		
		$res = mssql_execute($stmt);
		$xo = 0;
		
		if( $res ){
			while( $row = mssql_fetch_assoc($res)){
				$Notificacion = new Notificacion();
				$Notificacion->setTitulo( $row['Titulo'] );
				$Notificacion->setDescripcion( $row['Descripcion']);
				$Notificacion->setFecha( $row['Fecha']);
				$Notificacion->setUsuarioEnvia( $row['UsuarioEnvia']);
				$Notificacion->setId( $row['IdNotificacion']);
				$Notificacion->setUsuarioRecibe($row['UsuarioRecibe']);
				$Notificacion->setFechaLeida($row['FechaLeida']);
				$Notificacion->setLink($row['Link']);
				$Notificacion->setNombre($row['Nombre']);
				$Notificacion->setPaterno($row['Paterno']);
				$Notificacion->setMaterno($row['Materno']);
				$ListNot[$xo++] = $Notificacion;
			}
		}
		
		return $ListNot;
	} 