import psycopg2
import os

def handler(event, context):
    # Connect to database
    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        database=os.environ['DB_NAME'],
        user=os.environ['DB_ADMIN_USER'],
        password=os.environ['DB_ADMIN_PASSWORD'],
        port=os.environ['DB_PORT']
    )

    try:
        with conn.cursor() as cur:
            # Create users
            for user in event['users']:
                # Create user
                cur.execute(f"CREATE USER {user['username']} WITH PASSWORD '{user['password']}'")

                # Grant basic privileges
                cur.execute(f"GRANT CONNECT ON DATABASE {os.environ['DB_NAME']} TO {user['username']}")
                cur.execute(f"GRANT USAGE ON SCHEMA public TO {user['username']}")
                cur.execute(f"GRANT {user['permissions']} ON ALL TABLES IN SCHEMA public TO {user['username']}")

            conn.commit()

        return {
            'statusCode': 200,
            'body': 'Users created successfully'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error creating users: {str(e)}'
        }

    finally:
        conn.close()
