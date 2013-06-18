$(document).ready(function() {
    $('#content').getUpdate(function() {
        $('#content').load('/');
        setTimeout(getUpdate,1000)
    });
});

<script>
      function updateContent(){
        // Assuming we have #content
        $('#content').load('#content');
      }
      setInterval( "updateContent()", 1000 );
    </script>

<script>
      function updateContent(){
        // Assuming we have #content
        $('#content').load('/');
      }
      setInterval( "updateContent()", 1000 );
    </script>