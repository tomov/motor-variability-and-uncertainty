mkdir output

echo ---------------- >> jobs.txt
echo --- Running fit_params  >> jobs.txt
echo ---------------- >> jobs.txt

# params =
# s = 0.01, q = 0.1, sigma = 4, D = 10, beta = 1, tau = 10, ares = 24

declare -a fn_calls=(
                    "fit_params(5, @fit_3params_softmax)"
                    "fit_params(5, @fit_5params_softmax)"
                    "fit_params(5, @fit_4params_UCB)"
                    "fit_params(5, @fit_6params_UCB)"
                    "fit_params(5, @fit_2params_Thompson, 3000, 10)"
                    "fit_params(5, @fit_4params_Thompson, 3000, 10)"
                     )


outfileprefix="output/fit_params"
echo File prefix = $outfileprefix



for fn_call in "${fn_calls[@]}"
do
    echo $fn_call
    sbatch_output=`sbatch -p ncf_holy --mem 50001 -t 20-1:20 -o ${outfileprefix}_%j.out -e ${outfileprefix}_%j.err --wrap="matlab -nodisplay -nosplash -nojvm -r $'${fn_call};exit'"`
    sbatch_output_split=($sbatch_output)
    job_id=${sbatch_output_split[3]}
    echo $sbatch_output
    echo running $fn_call: ${outfileprefix}_${job_id}.out -- $sbatch_output >> jobs.txt

    sleep 1
done
