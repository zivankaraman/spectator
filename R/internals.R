
SafeNull <-
function(x)
{
    ifelse(is.null(x), NA, x)
}
